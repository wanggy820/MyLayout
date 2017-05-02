require('UIView, UIColor, UILabel, NSIndexPath')
defineClass('ViewController', {
    // replace the -genView method
    genView: function() {
        var view = self.ORIGgenView();//原来genView方法
        view.setBackgroundColor(UIColor.greenColor())
        var label = UILabel.alloc().initWithFrame({x:20, y:20, width:100, height:100});
        label.setText("JSPatch");
        label.setTextAlignment(1);
        label.sizeToFit();
        label.setBackgroundColor(UIColor.jrColorWithHex("#508CEE"));
        view.addSubview(label);
        

        console.log("****" + view.tag());
        return view;
    },
            
    animateTest: function() {
        self.test();
        console.log("dfdfdfdf=ww===");
        dispatch_after(1.0, function(){ 
            console.log("dfdfdfdf====");
        })
    },
    test: function() {
        UIView.animateWithDuration_animations(4, block(function() {
            var view = self.genView();
            // view.setFrame({x:200, y:200, width:100, height:100});
            view.frame().x = 0;
            view.setBackgroundColor(UIColor.redColor());
            self.performSelector_withObject("ddd:", nsnull);
        }));
    },
});
