/**
 * Asynchronously fetches data from the "/data" endpoint and populates
 * the table body with id "data-body" with the received data.
 * Each data entry is expected to have "timestamp", "light", "temperature", and "humidity" properties.
 * If any property is missing, an empty string is displayed in its place.
 *
 * @async
 * @function fetchData
 * @returns {Promise<void>} Resolves when the table has been updated with the fetched data.
 */
async function fetchData() {
    const res = await fetch("/data");
    const data = await res.json();

    const tbody = document.getElementById("data-body");
    tbody.innerHTML = "";

    data.forEach(doc => {
        const row = document.createElement("tr");

        row.innerHTML = `
            <td>${doc.timestamp || ""}</td>
            <td>${doc.light ?? ""}</td>
            <td>${doc.temperature ?? ""}</td>
            <td>${doc.humidity ?? ""}</td>
        `;

        tbody.appendChild(row);
    });
}
