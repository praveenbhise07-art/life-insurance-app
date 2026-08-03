// public/js/main.js
function handleQuoteSubmission() {
    const dob = document.getElementById('dob').value;
    const isSmoker = document.querySelector('input[name="isSmoker"]:checked').value === 'true';
    const coverageAmount = document.getElementById('coverage').value;
    const termYears = document.getElementById('term').value;

    if (!dob) { alert('Date of Birth is required.'); return; }

    // Save inputs to session storage for transfer to results page
    const quoteInputs = { dob, isSmoker, coverageAmount, termYears };
    sessionStorage.setItem('apexQuoteInputs', JSON.stringify(quoteInputs));

    // Simple browser redirect
    window.location.href = '/results';
}