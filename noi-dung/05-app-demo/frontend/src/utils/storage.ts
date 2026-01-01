import { User } from '../types';

const STORAGE_KEY = 'bookingms_user';

export const StorageService = {
  saveUser: (user: User | null) => {
    if (user) {
      localStorage.setItem(STORAGE_KEY, JSON.stringify(user));
    } else {
      localStorage.removeItem(STORAGE_KEY);
    }
  },

  getUser: (): User | null => {
    try {
      const stored = localStorage.getItem(STORAGE_KEY);
      return stored ? JSON.parse(stored) : null;
    } catch {
      return null;
    }
  },

  clearUser: () => {
    localStorage.removeItem(STORAGE_KEY);
  }
};
