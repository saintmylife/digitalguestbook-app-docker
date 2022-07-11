    // define audio variable
    const audio = new Audio('../assets/success.mp3');
    const sWelcome = new Audio('../assets/Welcome.wav');
    const sThankYou = new Audio('../assets/ThankYou.wav');
    const sAlready = new Audio('../assets/Already.wav');
    const sNotFound = new Audio('../assets/NotFound.wav');
    const sVip = new Audio('../assets/VIP.wav');
    const sVvip = new Audio('../assets/VVIP.wav');
    
    // get how many devices
    let manyCam;
    Html5Qrcode.getCameras().then(devices => {
        if(devices.length > 1){
            $('#btn-flipCam').css('display','flex');
            $('#btn-flipCam').css('visibility','unset');
            manyCam = true; 
        }else{
            $('#btn-flipCam').css('visibility','hidden');
            manyCam = false;
        }
        $('#disableCam').prop('checked');
        $('#frameScan').css('display','flex');
        $('#guest-name').html('Arahkan QRCode Anda Pada Bingkai');
    }).catch(err => {
        $('#frameScan').css('display','none');
        $('#disableCam').removeAttr('checked');
        $('#disableCam').attr('disabled','true');
        $('#guest-name').html('Tidak Dapat Mengakses Kamera Anda');
    });

    // ####### Web Cam Scanning #######
    let scanner = new QrScanner(video, result => sentGuest(result), error => {}, 1280, 'user');
    scanner.start().then(() => {
        setupCam('front');
    }).catch(err =>{
        alert('Camera Not Found');
    });
    window.scanner = scanner;

    // for aditional cam setup
    function setupCam(params){
        scanner.setInversionMode('both');
        scanner.$video.setAttribute('muted','true');
    };
    //
    function scannerDebug(params){
        $('#qr-video').css('visibility','hidden');
        $('#qr-scanner-box').append(scanner.$canvas);
        $('#qr-scanner-box canvas').css('display','block');
        if(params == 'user'){
            $('#qr-scanner-box canvas').css('transform','scaleX(-1)');
        }else{
            $('#qr-scanner-box canvas').css('transform','scaleX(1)');
        }
    };
    // getallperson
    function searchPerson() {
        $('#myInput').val('');
        $('#search-table').html('');
        $('#search-popup').css('display', 'block');
        $.ajax({
            type: 'GET',
            url: '/type_of_events/getalldata',
            beforeSend: function(){
                $('#content-loader').fadeIn('fast');
                if($('#counter-guest-modal').css('display') === 'grid'){
                    $('#btn-counter-skip').get(0).click();
                };
            },
            success: function (result) {
                let kategori;
                $.each(result['data'], function (index, val) {
                    kategori = val['kategori'] ? ' - '+val['kategori']:'';
                    $('#search-table').append("<div class='guest'><h2>" +
                        val['nama'] + "</h2><p>" + val['guest_id'] + kategori +
                        "</p><hr class='guest-hr'><div class='guest-masking' data-qr='" + val['guest_id'] +
                        "' data-name='" + val['nama'] + "'></div></div>")
                });
                setTimeout(() => {
                    $('#content-loader').fadeOut('slow');
                    $('#search-table').css('display','block');
                }, 250);
            }
        });
        $('#myInput').get(0).focus();
    };
    // close searchPerson when esc key is pressed
    let observer = new MutationObserver(function(event) {
        if(event[0].target.id === 'search-popup'){
        const popupTarget = document.getElementById(event[0].target.id);
           if(event[0].target.style.display === 'block'){
                popupTarget.addEventListener('keydown', function(keyPressed) {
                    if(keyPressed.key === 'Escape'){
                        $('#search-popup').fadeOut('fast');
                        $('#myInput').val('');
                    };
                });
            };
        };
    });
    observer.observe(document.getElementById('search-popup'), { attributes: true});
    // typing search person
    $("#myInput").on("keyup", function () {
        let value = $(this).val().toLowerCase();
        $("#search-table div").filter(function () {
            $(this).toggle($(this).text().toLowerCase().indexOf(value) > -1);
        });
    });
    // click on search person name
    $('#search-table').on('click', function (e) {
        let guestid = $(e.target).data('qr');
        let guestname = $(e.target).data('name');
        if (guestid) {
            $('#confirm-name').html(guestname);
            $('#confirm-id').html(guestid);
            $('#search-popup-confirm').css('display', 'flex');
            $('#search-popup-confirm').fadeIn();
        }
    })
    // search person confirmation box
    function userAns(answer) {
        if (answer) {
            let guestID = $('#confirm-id').html();
            $('#search-popup-confirm').fadeOut('fast');
            setTimeout(() => {
                $('#search-popup').fadeOut('fast');
                sentGuest(guestID);
            }, 500);
        }
    }
    function flipCam(){
        let camEnv = scanner._preferredFacingMode;
        let camCanvasSize = scanner._legacyCanvasSize;
        scanner.stop();
        scanner.destroy();
        scanner = null;
        let newCamEnv = (camEnv === "user") ? "environment" : "user";
        setTimeout(() => {
            // scanner.start();
            scanner = new QrScanner(video, result => sentGuest(result), error => {}, camCanvasSize, newCamEnv);
            scanner.start().then(() => {
                 setupCam(((newCamEnv === "user") ? "front" : "env"));
            }).catch(err =>{
                alert('Camera Not Found');
            });
        }, 500);
    }
    function options(){
        $('#options-modal').css('display','flex');
        $('#options-modal').animate({
            right:0
        });
        if($('#counter-guest-modal').css('display') === 'grid'){
            $('#btn-counter-skip').get(0).click();
        };
    };
    $('#options-modal').click(function(e) {
        if(e.target.id === 'options-modal'){
            $('#options-modal').animate({
                right:'-100%'
            });
            $('#options-modal').fadeOut();
        };
    });
    $('#options-modal-close').click(function(){
        $('#options-modal').animate({
            right:'-100%'
        });
        $('#options-modal').fadeOut();
    });
    $('#disableCam').on('change',function(e) {
        if(!e.target.checked){
            setTimeout(() => {
                scanner.stop();
                scanner.destroy();
                scanner = null;
            }, 250);
            $('#btn-flipCam').css('visibility','hidden');
             $('#frameScan').css('display','none');
        }else{
            setTimeout(() => {
                // checkCamera();
                scanner = new QrScanner(video, result => sentGuest(result), error => {}, 1280, 'user');
                scanner.start().then(() => {
                    setupCam("user");
                });
            }, 250);
            if(manyCam){
                $('#btn-flipCam').css('visibility','unset');
            }else{
                $('#btn-flipCam').css('visibility','hidden');
            };
             $('#frameScan').css('display','flex');
        };
    });
    $('#counterPerson').on('change',function (e) {
        if(e.target.checked){
            $(this).prop('checked');
        }else{
            $(this).removeAttr('checked');
        }
    })
    $('#debugScanner').on('change',function (e){
        let camEnv = scanner._preferredFacingMode;
        scannerDebug(camEnv);
    });
    function guestCounter(counter) {
        const inputGuest = document.getElementById('guest-counter-input');
        const inputMin = document.getElementById('guest-counter-minus');
        const inputPlus = document.getElementById('guest-counter-plus');
        let guestVal =  inputGuest.value;
        if(counter === 'minus'){
            guestVal--;
            inputMin.classList.add('counter-clicked');
        }else{
            guestVal++;
            inputPlus.classList.add('counter-clicked');
        }
        if(guestVal === 1){
            inputMin.setAttribute('disabled','true');
            inputMin.classList.add('counter-disabled');
        }else{
            inputMin.removeAttribute('disabled');
            inputMin.classList.remove('counter-disabled');
        };
        inputGuest.value = guestVal;
        setTimeout(() => {
            inputPlus.classList.remove('counter-clicked');
            inputMin.classList.remove('counter-clicked');
        }, 250);
    };
    function cancelGuestCounter(event_type,guestcode){
        const guestInformationMask = document.getElementById('guest-information-masking');
        $('#counter-guest-form-sign').fadeOut('slow');
        $('#counter-guest-modal').fadeOut('slow');
        // clear attribute onclick mask
        guestInformationMask.removeAttribute('onclick');
        setTimeout(() => {
            guestInformationMask.style.display = 'block';
            guestInformationMask.setAttribute('onclick','maskingGuestInformation(`'+event_type+'`,`'+guestcode.toString()+'`)');
        }, 500);
    };
    function maskingGuestInformation(event_type,guestcode){
        const counterPersonName = document.getElementById('counter-guest-form-sign-name');
        const btnCounterSubmit = document.getElementById('btn-counter-submit');
        const skipBtn = document.getElementById('btn-counter-skip');
        const guestName = document.getElementById('guest-name');
        // replace name
        counterPersonName.innerHTML = guestName.innerHTML;
        $('#counter-guest-modal').fadeIn('fast');
        $('#counter-guest-modal').css('display','grid');
        $('#counter-guest-form-sign').fadeIn('slow');
        btnCounterSubmit.setAttribute('onclick','submitGuestCounter(`'+event_type+'`,`'+guestcode.toString()+'`)');
        btnCounterSubmit.removeAttribute('disabled');
        skipBtn.removeAttribute('disabled');
        
    };
    function submitGuestCounter(event_type,guestcode) {
        const submitBtn = document.getElementById('btn-counter-submit');
        const skipBtn = document.getElementById('btn-counter-skip');
        const inputMin = document.getElementById('guest-counter-minus');
        const guestVal = document.getElementById('guest-counter-input');
        // const counterStatus = document.getElementById('counterStatus');
        const guestTotal = document.getElementById('guest-total');
        // const guestSign = document.getElementById('counter-guest-form-sign');
        const guestInformationMask = document.getElementById('guest-information-masking');
        $('#counter-guest-form-sign').fadeOut();
        submitBtn.setAttribute('disabled','true');
        skipBtn.setAttribute('disabled','true');
        // sent API
        $.ajax({
            type: 'PATCH',
            url: '/'+event_type.toLowerCase()+'/update_guest_brought_api',
            data: {
                type: event_type,
                guest_code: guestcode,
                guest_brought: guestVal.value
            },
            beforeSend: function(){
                $('#counterStatus').fadeIn('fast');
            },
            success: function (result) {
                if(result['message'] === 'Success'){
                    // let guestResult = 'Jumlah Orang = ' + guestVal.value;
                    let guestResult = 'Jumlah Orang = ' + result['jumlah_undangan'];
                    guestTotal.innerHTML = guestResult;
                    setTimeout(() => {
                        $('#counter-guest-modal').fadeOut('fast');
                        $('#counterStatus').fadeOut('fast');
                        submitBtn.removeAttribute('disabled');
                        skipBtn.removeAttribute('disabled');
                        inputMin.setAttribute('disabled','true');
                        inputMin.classList.add('counter-disabled');
                        guestInformationMask.removeAttribute('onclick');
                        guestInformationMask.style.display = 'none';
                    }, 1000);
                };
            }
        });
    };