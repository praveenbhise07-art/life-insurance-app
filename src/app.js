const express = require('express');
const path = require('path');
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static(path.join(__dirname, '../views')));

// --- Page Routes ---
app.get('/', (req, res) => {
  res.sendFile(path.join(__dirname, '../views/index.html'));
});

app.get('/apply', (req, res) => {
  res.sendFile(path.join(__dirname, '../views/quote-form.html'));
});

app.get('/quote', (req, res) => {
  res.sendFile(path.join(__dirname, '../views/quote-results.html'));
});

// --- Kubernetes Liveness & Readiness Probe Endpoint ---
app.get('/healthz', (req, res) => {
  res.status(200).json({ 
    status: 'UP', 
    service: 'Apex-Shield-Portal',
    timestamp: new Date().toISOString()
  });
});

// --- API Endpoint: Calculate Instant Term Life Quote ---
app.post('/api/quote', (req, res) => {
  const { dob, coverageAmount, termYears, smokerStatus } = req.body;
  
  if (!dob || !coverageAmount) {
    return res.status(400).json({ error: 'Missing required fields' });
  }

  // Calculate age from Date of Birth
  const birthDate = new Date(dob);
  const today = new Date();
  let age = today.getFullYear() - birthDate.getFullYear();
  const m = today.getMonth() - birthDate.getMonth();
  if (m < 0 || (m === 0 && today.getDate() < birthDate.getDate())) {
    age--;
  }

  // Rate calculation
  const baseRate = (age * 0.15) + (coverageAmount / 10000) * ((termYears || 20) / 10);
  const smokerMultiplier = (smokerStatus === 'yes') ? 1.8 : 1.0;
  const monthlyPremium = Math.max(15, baseRate * smokerMultiplier).toFixed(2);

  res.json({
    age,
    coverageAmount,
    termYears,
    smokerStatus,
    estimatedMonthlyPremium: `$${monthlyPremium}`,
    assignedAdvisor: "Sarah Jenkins, CFP (Senior Advisor, Life Division)"
  });
});

// Start server if run directly
if (require.main === module) {
  app.listen(PORT, () => {
    console.log(`Apex Shield InsurTech Application running on port ${PORT}`);
  });
}

module.exports = app;