<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Discount_Not_Approved</fullName>
        <field>StageName</field>
        <literalValue>Negotiation Rejected</literalValue>
        <name>Discount Not Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Stage</fullName>
        <field>StageName</field>
        <literalValue>Scheduled</literalValue>
        <name>Update Stage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>opportunity_owner_approves_the_discount</fullName>
        <description>opportunity owner approves the discount</description>
        <field>StageName</field>
        <literalValue>Scheduled</literalValue>
        <name>opportunity owner approves the discount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
</Workflow>
