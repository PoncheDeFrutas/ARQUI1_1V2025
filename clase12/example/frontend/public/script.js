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
