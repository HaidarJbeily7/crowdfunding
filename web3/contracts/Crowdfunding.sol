// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Crowdfunding {
    
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 targetMoney;
        uint256 deadline;
        uint256 amountCollected;
        string imageUrl;
        address[] donators;
        uint256[] donations;
    }

    mapping (uint256 => Campaign) public campaigns;

    uint256 public numOfCampaigns = 0;

    function  createCampaign(address _owner, string memory _title, string memory _description, 
     uint256 _targetMoney, uint256 _deadline,string memory _imageUrl) public returns (uint256){

        Campaign storage campaign = campaigns[numOfCampaigns];

        require(campaign.deadline < block.timestamp, "Deadline is invalid!");

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.targetMoney = _targetMoney;
        campaign.deadline = _deadline;
        campaign.imageUrl = _imageUrl;
        campaign.amountCollected = 0;
        
        numOfCampaigns++;

        return numOfCampaigns - 1;

    }

    function donateToCampaign(uint256 _campaignId) public payable{
        uint256 amount = msg.value;
        Campaign storage campaign = campaigns[_campaignId];

        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent,)= payable(campaign.owner).call{value: amount}("");

        if(sent){
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    function getDonators(uint256 _campaignId) view public returns(address[] memory, uint256[] memory){
        Campaign storage campaign = campaigns[_campaignId];

        return (campaign.donators, campaign.donations);
    }

    function getCampaigns() public view returns (Campaign[] memory){
        Campaign[] memory allCampaigns = new Campaign[](numOfCampaigns);

        for(uint256 _id=0; _id < numOfCampaigns; _id++){
            Campaign storage item = campaigns[_id];
            allCampaigns[_id] = item;
        }
        return allCampaigns;
    }

}