import bcrypt from 'bcrypt';
import { getPool } from '../config/database.js';
import { SEED_USERS, SEED_ROOMS, SEED_BOOKINGS, SEED_TRANSACTIONS } from '../data/seedData.js';

// ============================================================================
// DATABASE SEED SCRIPT
// ============================================================================

async function seedDatabase() {
  try {
    const pool = await getPool();
    console.log('🌱 Starting database seeding...');

    // 1. Clear existing data (optional - comment out if you want to keep data)
    console.log('🧹 Clearing existing data...');
    await pool.request().query('DELETE FROM Transactions');
    await pool.request().query('DELETE FROM Bookings');
    await pool.request().query('DELETE FROM Rooms');
    await pool.request().query('DELETE FROM Users');

    // 2. Seed Users
    console.log('👥 Seeding users...');
    for (const user of SEED_USERS) {
      const hashedPassword = await bcrypt.hash(user.password, 10);
      await pool.request()
        .input('id', user.id)
        .input('name', user.name)
        .input('email', user.email)
        .input('password', hashedPassword)
        .input('phone', user.phone)
        .input('role', user.role)
        .input('status', user.status)
        .query(`
          INSERT INTO Users (id, name, email, password, phone, role, status, createdAt)
          VALUES (@id, @name, @email, @password, @phone, @role, @status, GETDATE())
        `);
      console.log(`  ✓ Created user: ${user.email}`);
    }

    // 3. Seed Rooms
    console.log('🏨 Seeding rooms...');
    for (const room of SEED_ROOMS) {
      await pool.request()
        .input('id', room.id)
        .input('name', room.name)
        .input('type', room.type)
        .input('capacity', room.capacity)
        .input('price', room.price)
        .input('amenities', JSON.stringify(room.amenities))
        .input('imageUrl', room.imageUrl)
        .input('status', room.status)
        .input('description', room.description)
        .query(`
          INSERT INTO Rooms (id, name, type, capacity, price, amenities, imageUrl, status, description, createdAt, updatedAt)
          VALUES (@id, @name, @type, @capacity, @price, @amenities, @imageUrl, @status, @description, GETDATE(), GETDATE())
        `);
      console.log(`  ✓ Created room: ${room.name}`);
    }

    // 4. Seed Bookings
    console.log('📅 Seeding bookings...');
    for (const booking of SEED_BOOKINGS) {
      await pool.request()
        .input('id', booking.id)
        .input('userId', booking.userId)
        .input('roomId', booking.roomId)
        .input('checkIn', new Date(booking.checkIn))
        .input('checkOut', new Date(booking.checkOut))
        .input('guests', booking.guests)
        .input('totalAmount', booking.totalAmount)
        .input('status', booking.status)
        .input('paymentStatus', booking.paymentStatus)
        .input('specialRequests', booking.specialRequests)
        .query(`
          INSERT INTO Bookings (id, userId, roomId, checkIn, checkOut, guests, totalAmount, status, paymentStatus, specialRequests, createdAt, updatedAt)
          VALUES (@id, @userId, @roomId, @checkIn, @checkOut, @guests, @totalAmount, @status, @paymentStatus, @specialRequests, GETDATE(), GETDATE())
        `);
      console.log(`  ✓ Created booking: ${booking.id}`);
    }

    // 5. Seed Transactions
    console.log('💰 Seeding transactions...');
    for (const trx of SEED_TRANSACTIONS) {
      await pool.request()
        .input('id', trx.id)
        .input('bookingId', trx.bookingId)
        .input('userId', trx.userId)
        .input('amount', trx.amount)
        .input('method', trx.method)
        .input('type', trx.type)
        .input('status', trx.status)
        .input('note', trx.note)
        .query(`
          INSERT INTO Transactions (id, bookingId, userId, amount, method, type, status, note, createdAt)
          VALUES (@id, @bookingId, @userId, @amount, @method, @type, @status, @note, GETDATE())
        `);
      console.log(`  ✓ Created transaction: ${trx.id}`);
    }

    console.log('\n✅ Database seeded successfully!');
    console.log(`
📊 Summary:
  - Users: ${SEED_USERS.length}
  - Rooms: ${SEED_ROOMS.length}
  - Bookings: ${SEED_BOOKINGS.length}
  - Transactions: ${SEED_TRANSACTIONS.length}

🔑 Demo Accounts:
  User:  user@demo.com / password123
  Admin: admin@demo.com / admin123
    `);

    process.exit(0);
  } catch (error) {
    console.error('❌ Seed failed:', error);
    process.exit(1);
  }
}

seedDatabase();
