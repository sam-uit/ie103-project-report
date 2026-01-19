import React from 'react';
import { HashRouter, Routes, Route, Navigate } from 'react-router-dom';
import Layout from './components/Layout';
import Overview from './pages/Overview';
import Dashboard from './pages/Dashboard';
import ScenarioDetail from './pages/ScenarioDetail';
import Reports from './pages/Reports';
import Logs from './pages/Logs';
import Settings from './pages/Settings';
import { ConfigProvider } from './contexts/ConfigContext';

const App: React.FC = () => {
      return (
            <ConfigProvider>
                  <HashRouter>
                        <Layout>
                              <Routes>
                                    <Route path="/" element={<Overview />} />
                                    <Route path="/scenarios" element={<Dashboard />} />
                                    <Route path="/scenario/:id" element={<ScenarioDetail />} />
                                    <Route path="/reports" element={<Reports />} />
                                    <Route path="/logs" element={<Logs />} />
                                    <Route path="/settings" element={<Settings />} />
                                    <Route path="*" element={<Navigate to="/" replace />} />
                              </Routes>
                        </Layout>
                  </HashRouter>
            </ConfigProvider>
      );
};

export default App;