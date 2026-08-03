const request = require('supertest');
const app = require('./app');

describe('Term Life Insurance API Tests', () => {
  it('GET /healthz should return cluster health status', async () => {
    const res = await request(app).get('/healthz');
    expect(res.statusCode).toEqual(200);
    expect(res.body.status).toEqual('UP');
  });

  it('POST /api/quote should calculate term life monthly premium', async () => {
    const res = await request(app)
      .post('/api/quote')
      .send({ 
        dob: '1990-05-15', 
        coverageAmount: 500000, 
        termYears: 20, 
        smokerStatus: 'no' 
      });
    
    expect(res.statusCode).toEqual(200);
    expect(res.body).toHaveProperty('estimatedMonthlyPremium');
    expect(res.body).toHaveProperty('assignedAdvisor');
  });
});