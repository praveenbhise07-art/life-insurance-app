// public/js/results.js
document.addEventListener('DOMContentLoaded', async () => {
    const inputsString = sessionStorage.getItem('apexQuoteInputs');
    if (!inputsString) { window.location.href = '/quote'; return; } // Redirect if no input found

    const inputs = JSON.parse(inputsString);

    // Call the complex API on the server (simulating Jenkins 'Build' stage passing artifacts)
    const response = await fetch('/api/quote', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(inputs)
    });

    if (!response.ok) { document.getElementById('loadingState').innerHTML = '<h2>Error Calculating Quote. Please try again.</h2>'; return; }

    const data = await response.json();

    // Populate the results UI
    document.getElementById('premiumVal').innerText = data.estimatedMonthlyPremium;
    document.getElementById('coverageVal').innerText = data.coverageAmount;
    document.getElementById('termVal').innerText = data.termYears;
    document.getElementById('ageVal').innerText = data.age;
    document.getElementById('statusVal').innerText = data.isSmoker;
    document.getElementById('advisorVal').innerText = data.assignedAdvisor;

    // Show results
    document.getElementById('loadingState').style.display = 'none';
    document.getElementById('resultsBox').style.display = 'block';

    // Cleanup session storage
    sessionStorage.removeItem('apexQuoteInputs');
});