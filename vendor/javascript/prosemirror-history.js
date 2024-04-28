import e from"rope-sequence";import{Mapping as t}from"prosemirror-transform";import{PluginKey as n,Plugin as s}from"prosemirror-state";const r=500;class Branch{constructor(e,t){this.items=e;this.eventCount=t}popEvent(e,t){if(0==this.eventCount)return null;let n=this.items.length;for(;;n--){let e=this.items.get(n-1);if(e.selection){--n;break}}let s,r;if(t){s=this.remapping(n,this.items.length);r=s.maps.length}let i=e.tr;let o,a;let p=[],l=[];this.items.forEach(((e,t)=>{if(e.step){if(s){l.push(new Item(e.map));let t,n=e.step.map(s.slice(r));if(n&&i.maybeStep(n).doc){t=i.mapping.maps[i.mapping.maps.length-1];p.push(new Item(t,void 0,void 0,p.length+l.length))}r--;t&&s.appendMap(t,r)}else i.maybeStep(e.step);if(e.selection){o=s?e.selection.map(s.slice(r)):e.selection;a=new Branch(this.items.slice(0,n).append(l.reverse().concat(p)),this.eventCount-1);return false}}else{if(!s){s=this.remapping(n,t+1);r=s.maps.length}r--;l.push(e)}}),this.items.length,0);return{remaining:a,transform:i,selection:o}}addTransform(e,t,n,s){let r=[],o=this.eventCount;let a=this.items,p=!s&&a.length?a.get(a.length-1):null;for(let n=0;n<e.steps.length;n++){let i=e.steps[n].invert(e.docs[n]);let l,m=new Item(e.mapping.maps[n],i,t);if(l=p&&p.merge(m)){m=l;n?r.pop():a=a.slice(0,a.length-1)}r.push(m);if(t){o++;t=void 0}s||(p=m)}let l=o-n.depth;if(l>i){a=cutOffEvents(a,l);o-=l}return new Branch(a.append(r),o)}remapping(e,n){let s=new t;this.items.forEach(((t,n)=>{let r=null!=t.mirrorOffset&&n-t.mirrorOffset>=e?s.maps.length-t.mirrorOffset:void 0;s.appendMap(t.map,r)}),e,n);return s}addMaps(e){return 0==this.eventCount?this:new Branch(this.items.append(e.map((e=>new Item(e)))),this.eventCount)}rebased(e,t){if(!this.eventCount)return this;let n=[],s=Math.max(0,this.items.length-t);let i=e.mapping;let o=e.steps.length;let a=this.eventCount;this.items.forEach((e=>{e.selection&&a--}),s);let p=t;this.items.forEach((t=>{let s=i.getMirror(--p);if(null==s)return;o=Math.min(o,s);let r=i.maps[s];if(t.step){let o=e.steps[s].invert(e.docs[s]);let l=t.selection&&t.selection.map(i.slice(p+1,s));l&&a++;n.push(new Item(r,o,l))}else n.push(new Item(r))}),s);let l=[];for(let e=t;e<o;e++)l.push(new Item(i.maps[e]));let m=this.items.slice(0,s).append(l).append(n);let h=new Branch(m,a);h.emptyItemCount()>r&&(h=h.compress(this.items.length-n.length));return h}emptyItemCount(){let e=0;this.items.forEach((t=>{t.step||e++}));return e}compress(t=this.items.length){let n=this.remapping(0,t),s=n.maps.length;let r=[],i=0;this.items.forEach(((e,o)=>{if(o>=t){r.push(e);e.selection&&i++}else if(e.step){let t=e.step.map(n.slice(s)),o=t&&t.getMap();s--;o&&n.appendMap(o,s);if(t){let a=e.selection&&e.selection.map(n.slice(s));a&&i++;let p,l=new Item(o.invert(),t,a),m=r.length-1;(p=r.length&&r[m].merge(l))?r[m]=p:r.push(l)}}else e.map&&s--}),this.items.length,0);return new Branch(e.from(r.reverse()),i)}}Branch.empty=new Branch(e.empty,0);function cutOffEvents(e,t){let n;e.forEach(((e,s)=>{if(e.selection&&0==t--){n=s;return false}}));return e.slice(n)}class Item{constructor(e,t,n,s){this.map=e;this.step=t;this.selection=n;this.mirrorOffset=s}merge(e){if(this.step&&e.step&&!e.selection){let t=e.step.merge(this.step);if(t)return new Item(t.getMap().invert(),t,this.selection)}}}class HistoryState{constructor(e,t,n,s,r){this.done=e;this.undone=t;this.prevRanges=n;this.prevTime=s;this.prevComposition=r}}const i=20;function applyTransaction(e,t,n,s){let r,i=n.getMeta(p);if(i)return i.historyState;n.getMeta(l)&&(e=new HistoryState(e.done,e.undone,null,0,-1));let o=n.getMeta("appendedTransaction");if(0==n.steps.length)return e;if(o&&o.getMeta(p))return o.getMeta(p).redo?new HistoryState(e.done.addTransform(n,void 0,s,mustPreserveItems(t)),e.undone,rangesFor(n.mapping.maps[n.steps.length-1]),e.prevTime,e.prevComposition):new HistoryState(e.done,e.undone.addTransform(n,void 0,s,mustPreserveItems(t)),null,e.prevTime,e.prevComposition);if(false===n.getMeta("addToHistory")||o&&false===o.getMeta("addToHistory"))return(r=n.getMeta("rebased"))?new HistoryState(e.done.rebased(n,r),e.undone.rebased(n,r),mapRanges(e.prevRanges,n.mapping),e.prevTime,e.prevComposition):new HistoryState(e.done.addMaps(n.mapping.maps),e.undone.addMaps(n.mapping.maps),mapRanges(e.prevRanges,n.mapping),e.prevTime,e.prevComposition);{let r=n.getMeta("composition");let i=0==e.prevTime||!o&&e.prevComposition!=r&&(e.prevTime<(n.time||0)-s.newGroupDelay||!isAdjacentTo(n,e.prevRanges));let a=o?mapRanges(e.prevRanges,n.mapping):rangesFor(n.mapping.maps[n.steps.length-1]);return new HistoryState(e.done.addTransform(n,i?t.selection.getBookmark():void 0,s,mustPreserveItems(t)),Branch.empty,a,n.time,null==r?e.prevComposition:r)}}function isAdjacentTo(e,t){if(!t)return false;if(!e.docChanged)return true;let n=false;e.mapping.maps[0].forEach(((e,s)=>{for(let r=0;r<t.length;r+=2)e<=t[r+1]&&s>=t[r]&&(n=true)}));return n}function rangesFor(e){let t=[];e.forEach(((e,n,s,r)=>t.push(s,r)));return t}function mapRanges(e,t){if(!e)return null;let n=[];for(let s=0;s<e.length;s+=2){let r=t.map(e[s],1),i=t.map(e[s+1],-1);r<=i&&n.push(r,i)}return n}function histTransaction(e,t,n,s){let r=mustPreserveItems(t);let i=p.get(t).spec.config;let o=(s?e.undone:e.done).popEvent(t,r);if(!o)return;let a=o.selection.resolve(o.transform.doc);let l=(s?e.done:e.undone).addTransform(o.transform,t.selection.getBookmark(),i,r);let m=new HistoryState(s?l:o.remaining,s?o.remaining:l,null,0,-1);n(o.transform.setSelection(a).setMeta(p,{redo:s,historyState:m}).scrollIntoView())}let o=false,a=null;function mustPreserveItems(e){let t=e.plugins;if(a!=t){o=false;a=t;for(let e=0;e<t.length;e++)if(t[e].spec.historyPreserveItems){o=true;break}}return o}function closeHistory(e){return e.setMeta(l,true)}const p=new n("history");const l=new n("closeHistory");function history(e={}){e={depth:e.depth||100,newGroupDelay:e.newGroupDelay||500};return new s({key:p,state:{init(){return new HistoryState(Branch.empty,Branch.empty,null,0,-1)},apply(t,n,s){return applyTransaction(n,s,t,e)}},config:e,props:{handleDOMEvents:{beforeinput(e,t){let n=t.inputType;let s="historyUndo"==n?undo:"historyRedo"==n?redo:null;if(!s)return false;t.preventDefault();return s(e.state,e.dispatch)}}}})}const undo=(e,t)=>{let n=p.getState(e);if(!n||0==n.done.eventCount)return false;t&&histTransaction(n,e,t,false);return true};const redo=(e,t)=>{let n=p.getState(e);if(!n||0==n.undone.eventCount)return false;t&&histTransaction(n,e,t,true);return true};function undoDepth(e){let t=p.getState(e);return t?t.done.eventCount:0}function redoDepth(e){let t=p.getState(e);return t?t.undone.eventCount:0}export{closeHistory,history,redo,redoDepth,undo,undoDepth};

