Like many programmers over the past two weeks, I have been experimenting with Apple's newly announced [Swift Programming language](https://developer.apple.com/swift/).  I've been working (slowly) on porting my recent [ludum dare entry "Dig'em"](http://www.ludumdare.com/compo/ludum-dare-29/?action=preview&uid=8599) over to the new language as an iOS application.

In doing this I have been learning how to use Apple's [Sprite Kit game libarary](https://developer.apple.com/library/ios/documentation/GraphicsAnimation/Conceptual/SpriteKit_PG/Introduction/Introduction.html).  Last night I started looking at how Sprite Kit handles collision detection and found the `SKPhysicsContactDelegate` protocol.  You can conform to this protocal by implementing two methods `didBeginContact` and `didEndContact` which will get fired for every collision that happens between two `SKNodes` in your scene.  Here is an example:


    class GameScene: SKScene, SKPhysicsContactDelegate {
        init() {
            super.init()
            self.physicsWorld.contactDelegate = self
        }
        func didBeginContact(contact: SKPhysicsContact) {
            // check the contact.bodyA and contact.bodyB and see if you need to do something
        }
    }

This way, you then check the nodes that are stored in the contact object to see if you need to do any particular processing for a certain type of collision.  For instance, you can kill your hero if he/she collided with a lava object.  Because there are so many varieties of collision that can occur in a more than trivial game, I wanted a way for an `SKNode` to be able to keep track of it's own collision logic, rather than store all of that in one method with a potentially high amount of branching logic.  However, I didn't want to subclass `SKNode` and downcast from the delegate method, because that meant creating an extra layer between me and Sprite Kit just to do custom collision logic.

Swift offers the ability to extend existing objects with new methods or variables.  What's cool is in extending these objects, you can also add new protocols (swift's equivalent of an interface), effectively giving existing objects new types to conform to.  I am able to offload collision detection logic to the `SKNode` with the following code:

    @objc protocol Collidable {
        @optional func onContact(contact: SKPhysicsContact)
        @optional func onEndContact(contact: SKPhysicsContact)
    }

    extension SKNode : Collidable {
        func distanceTo(point: CGPoint) -> CGFloat {
            return hypotf(point.x - self.position.x, point.y - self.position.y);
        }
    }

Here is where things get interesting.  By making the methods in the `Collidable` protocal optional, the methods `onContact` and `onEndContact` aren't guranteed to exist.  Swift allows you to call these optional methods by appending a ? to the end of a call to indicate the method might not be there. Here is how my `didContactBegin` method looks now:

    func didBeginContact(contact: SKPhysicsContact) {
        let bodyA = contact.bodyA.node as Collidable
        bodyA.onContact?(contact)
    }    

Now for any collisions that occur, the contact delegate will simply try to call onContact on the first node listed in the collision, and do nothing if the method is not there.  I can implement custom collision logic in my nodes by doing the following:

    class HeroNode : SKNode {
        init() {
            super.init()
        }
        func onContact(contact: SKPhysicsContact) {
            // do custom collision logic here
        }
    }

I was a little dissapointed that I had to cast the node to a Collidable before the onContact method was recognized, but I am pleased overall with what I was able to accomplish.  

Being able to extend existing classes with new protocols is a cool idea and I am interested to see how other developers use this feature in the future.




