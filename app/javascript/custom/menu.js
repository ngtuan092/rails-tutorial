document.addEventListener("turbo:load", function() {
    let account = document.getElementById("account");
    account.addEventListener("click", function(event) {
        event.preventDefault();
        let menu = document.getElementById("dropdown-menu");
        menu.classList.toggle("active");
    });
});
