import {Controller} from "@hotwired/stimulus"

// Connects to data-controller="chart"
export default class extends Controller {
    // static values = {
    //     options: Object,
    // };

    connect() {
        if (typeof Chart === undefined) {
            throw new Error('Chart.js is required to use the chart controller');
        }
        new Chart(this.element.getContext('2d'), {
            type: "pie",
            data: {
                labels: Object.keys({}),
                datasets: [{
                    label: "Participantes por ciudad",
                    data: Object.values({}),
                }]
            },
            options: {
                responsive: true,
                plugins: {
                    legend: {position: 'bottom'},
                },
            }
        });
        console.log(Chart.version)
    }
}
