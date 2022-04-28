pragma solidity ^0.5.0;

contract Decentragram {
  string public name = "Decentragram";

  uint public imageCount = 0;
  // store images
  //mapping acts as a database key => value pairs(array)
  mapping(uint => Image) public images;

  //struct helps you define your data type
  struct Image {
    uint id;
    string hash;
    string description;
    uint tipAmount;
    address payable author;
  }

  event ImageCreated(
    uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  event ImageTipped(
     uint id,
    string hash,
    string description,
    uint tipAmount,
    address payable author
  );

  //create an Image
  function uploadImage(string memory _imageHash, string memory _description) public{

    //make sure image hash exists
    require(bytes(_imageHash).length > 0);

    //make sure image description exists
    require(bytes(_description).length > 0);

    //make sure uploader address exists
    require(msg.sender != address(0x0));

    //increment id count
    imageCount ++;

    //add images to contract
      images[imageCount] = Image(imageCount, _imageHash, _description, 0, msg.sender);

    //trigger an event
      emit ImageCreated(imageCount, _imageHash, _description, 0, msg.sender);

  }

  //Tip Images
   function tipImageOwner(uint _id) public payable {
     require(_id > 0 && _id <= imageCount);

     Image memory _image = images[_id];
     address payable _author = _image.author;
     //pay the author by sending them ether
     address (_author).transfer(msg.value);
     //increment the tip amount
     _image.tipAmount = _image.tipAmount + msg.value;
     //update the image
     images[_id] = _image;
     //emit tippedEvent
     emit ImageTipped(_id, _image.hash, _image.description, _image.tipAmount, _author);
   }


}