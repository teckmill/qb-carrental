let categories = {};
let selectedCategory = null;
let selectedVehicle = null;
let selectedDuration = null;
let selectedInsurance = null;
let loyaltyPoints = 0;
let loyaltyDiscount = 0;

$(document).ready(function() {
    window.addEventListener('message', function(event) {
        let data = event.data;

        if (data.action === 'openMenu') {
            $('body').show();
            $('#rental-container').addClass('show');
            loadCategories(data.categories);
            if (data.loyalty) {
                loadLoyaltyData(data.loyalty);
            }
        } else if (data.action === 'close') {
            closeMenu();
        }
    });

    $('#close-btn').click(closeMenu);
    
    // ESC key to close
    $(document).keyup(function(e) {
        if (e.key === "Escape") {
            closeMenu();
        }
    });
});

function loadCategories(categories) {
    const container = $('.categories-grid');
    container.empty();

    categories.forEach(category => {
        const element = $(`
            <div class="category" data-category="${category.name}">
                <h3>${category.label}</h3>
                <p>${category.description}</p>
            </div>
        `);

        element.click(() => showVehicles(category.name));
        container.append(element);
    });

    $('#categories-container').show();
    $('#vehicles-container').hide();
    $('#rental-details').hide();
}

function showVehicles(category) {
    selectedCategory = category;
    $.post('https://qb-carrentals/getVehicles', JSON.stringify({ category }), function(vehicles) {
        const container = $('.vehicles-grid');
        container.empty();

        vehicles.forEach(vehicle => {
            const element = $(`
                <div class="vehicle" data-vehicle="${vehicle.model}">
                    <h3>${vehicle.name}</h3>
                    <p>Base Price: $${vehicle.price}</p>
                    <p>Deposit: $${vehicle.deposit}</p>
                </div>
            `);

            element.click(() => showRentalDetails(vehicle));
            container.append(element);
        });

        $('#categories-container').hide();
        $('#vehicles-container').show();
        $('#rental-details').hide();
    });
}

function showRentalDetails(vehicle) {
    selectedVehicle = vehicle;
    $('#vehicle-name').text(vehicle.name);
    $('#base-price').text(`$${vehicle.price}`);

    // Load duration options
    const durationContainer = $('.duration-options');
    durationContainer.empty();
    
    [1, 2, 3, 4, 5, 6, 7].forEach(days => {
        const element = $(`
            <div class="duration-option" data-days="${days}">
                ${days} Day${days > 1 ? 's' : ''}
            </div>
        `);

        element.click(() => selectDuration(days));
        durationContainer.append(element);
    });

    // Set up insurance options click handlers
    $('.insurance-option').click(function() {
        $('.insurance-option').removeClass('selected');
        $(this).addClass('selected');
        selectedInsurance = $(this).data('insurance');
        updatePriceBreakdown();
    });

    $('#vehicles-container').hide();
    $('#rental-details').show();
    updatePriceBreakdown();
}

function selectDuration(days) {
    selectedDuration = days;
    $('.duration-option').removeClass('selected');
    $(`.duration-option[data-days="${days}"]`).addClass('selected');
    updatePriceBreakdown();
}

function loadLoyaltyData(data) {
    loyaltyPoints = data.points;
    loyaltyDiscount = calculateLoyaltyDiscount(data.points);
    
    $('#loyalty-points').text(`Points: ${loyaltyPoints}`);
    $('#loyalty-discount').text(`Current Discount: ${loyaltyDiscount}%`);
}

function calculateLoyaltyDiscount(points) {
    if (points >= 500) return 15;
    if (points >= 250) return 10;
    if (points >= 100) return 5;
    return 0;
}

function updatePriceBreakdown() {
    if (!selectedVehicle || !selectedDuration) return;

    const basePrice = selectedVehicle.price * selectedDuration;
    let insuranceCost = 0;
    
    if (selectedInsurance === 'basic') {
        insuranceCost = basePrice * 0.15;
    } else if (selectedInsurance === 'premium') {
        insuranceCost = basePrice * 0.25;
    }

    const loyaltyDiscountAmount = (basePrice + insuranceCost) * (loyaltyDiscount / 100);

    $('#breakdown-base').text(`$${basePrice}`);
    $('#breakdown-insurance').text(`$${insuranceCost}`);
    $('#breakdown-discount').text(`-$${loyaltyDiscountAmount}`);
    $('#total-price').text(`$${basePrice + insuranceCost - loyaltyDiscountAmount}`);
}

function confirmRental() {
    if (!selectedVehicle || !selectedDuration || !selectedInsurance) {
        // Show error notification
        return;
    }

    const rentalData = {
        vehicle: selectedVehicle.model,
        duration: selectedDuration,
        insurance: selectedInsurance,
        totalPrice: parseFloat($('#total-price').text().replace('$', '')),
        deposit: selectedVehicle.deposit
    };

    $.post('https://qb-carrentals/rentVehicle', JSON.stringify(rentalData));
    closeMenu();
}

function resetMenu() {
    selectedCategory = null;
    selectedVehicle = null;
    selectedDuration = null;
    selectedInsurance = null;
    
    $('#categories-container').show();
    $('#vehicles-container').hide();
    $('#rental-details').hide();
}

function closeMenu() {
    $('body').hide();
    $('#rental-container').removeClass('show');
    $.post('https://qb-carrentals/closeMenu');
    resetMenu();
}
