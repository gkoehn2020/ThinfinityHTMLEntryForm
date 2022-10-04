
const componentOneStyle = `@charset "utf-8";
.loading-overlay {
    background: rgba( 26,26,26,0.7 );
    /* position: fixed; */
    width: 100%;
    height: 100%;
    z-index: 5;
    top: 0;
}

.loading-overlay-img-container {
    position: absolute;
    z-index: 7;
    top: 50%;
    left: 50%;
    transform: translate( -50%, -50% );
}

.loading-overlay-img {
    width: 160px;
    height: 24px;
    border-radius: 5px;
}

.orion-working-hidden {
    display: none;
}

#orion-working-msg {
  text-align: center;
  color: white;
}
`;

const addCSS = codeToAdd => document.head.appendChild(document.createElement("style")).innerHTML = codeToAdd;
addCSS(componentOneStyle);

xtag.register('x-entryform1', {
  content: `<div class="loading-overlay orion-working-hidden"></div>
            <div class="loading-overlay-img-container orion-working-hidden">
              <!-- The Modal -->
              <div id="orModal" class="ormodal">
                <!-- Modal content -->
                <div class="ormodal-content">
                   
                  <form id="form">
                
                    <p>Orion Dictation Entry</p>
                    <textarea id="orNarrative" name="orNarrative" rows="20" cols="100" class="orNarrative"></textarea> 
                    <div>
                      <i class="pointer fa fa-2xs fa-microphone-slash" id="mic"></i>
                      <button id="orBtnCancel" type="button" class="btncancel">Cancel</button>
                      <button class="btnsave">Save</button>
                    </div>
                  
                  </form>
                </div>
              </div>                
            </div>`,
  lifecycle: {
    created  : function(){ 
      /* Called when the custom element is created */ 
    },
    inserted : function(){ 
      /* Called when the custom element is inserted into the DOM */ 
      var _controlID = this.id;

      jsro = new Thinfinity.JsRO();
      jsro.on('model:' + _controlID, 'created', function (obj) {
          ro = jsro.model[_controlID];
      });
      
      jsro.on(_controlID, "ShowThisModal", function () {
        const div =  document.querySelector('.loading-overlay');
        div.classList.remove('orion-working-hidden');
        const div2 =  document.querySelector('.loading-overlay-img-container');
        div2.classList.remove('orion-working-hidden');     
        console.trace('start');
      });

      document.getElementById("orBtnCancel").onclick = function() {
        const div =  document.querySelector('.loading-overlay');
        div.classList.add('orion-working-hidden');
        const div2 =  document.querySelector('.loading-overlay-img-container');
        div2.classList.add('orion-working-hidden');
        ro.orCancel();
      };   
      
    },
    removed  : function(){ 
      /* Called when the custom element is removed from the DOM */ 
    },
    attributeChanged: function(attrName, oldValue, newValue){
      /* Called when the attribute of the custom element is changed */
    }
  },
  accessors : {},
  methods   : {},
  events    : {}
});

