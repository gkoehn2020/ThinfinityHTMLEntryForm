
const componentOneStyle = `@charset "utf-8";
.orOverlay {
    background: rgba( 26,26,26,0.7 );
    /* position: fixed; */
    width: 100%;
    height: 100%;
    z-index: 5;
    top: 0;
}

.orOverlayContainer {
    position: absolute;
    z-index: 7;
    top: 50%;
    left: 50%;
    transform: translate( -50%, -50% );
}

.orModalHidden {
    display: none;
}

.ormodal-content {
  background-color: #fefefe;
  margin: auto;
  padding: 20px;
  border: 1px solid #888;
  width: 80%;
  max-width: 760px;
  min-width: 759px;
}

.orNarrative {
  resize: none;
}

.orBtnCancel {
  float: right;
  margin-right: 4px; 
  width: 100px;
}

.orBtnsave {
  float: right;
  margin-right: 10px;
  width: 100px;
}

`;

const addCSS = codeToAdd => document.head.appendChild(document.createElement("style")).innerHTML = codeToAdd;
addCSS(componentOneStyle);

xtag.register('x-entryform1', {
  content: `<div class="orOverlay orModalHidden"></div>
            <div class="orOverlayContainer orModalHidden">
              <!-- The Modal -->
              <div id="orModal" class="ormodal">
                <!-- Modal content -->
                <div class="ormodal-content">
                   
                  <form id="form">
                
                    <p>Dictation Entry</p>
                    <textarea id="orNarrative" name="orNarrative" rows="20" cols="100" class="orNarrative"></textarea> 
                    <div>
                      <i class="pointer fa fa-2xs fa-microphone-slash" id="mic"></i>
                      <button id="orBtnCancel" type="button" class="orBtnCancel">Cancel</button>
                      <button class="orBtnsave">Save</button>
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
        const div =  document.querySelector('.orOverlay');
        div.classList.remove('orModalHidden');
        const div2 =  document.querySelector('.orOverlayContainer');
        div2.classList.remove('orModalHidden');     
        console.trace('start');
      });

      document.getElementById("orBtnCancel").onclick = function() {
        const div =  document.querySelector('.orOverlay');
        div.classList.add('orModalHidden');
        const div2 =  document.querySelector('.orOverlayContainer');
        div2.classList.add('orModalHidden');
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

