// rogue agent is a type of sensing agent

/* Initial beliefs and rules */

my_master(Celcius) :- temperature(Celcius)[source(sensing_agent_9)].

// initially, the agent believes that it hasn't received any temperature readings
received_readings([]).

/* Initial goals */
!set_up_plans. // the agent has the goal to add pro-rogue plans

/* 
 * Plan for reacting to the addition of the goal !set_up_plans
 * Triggering event: addition of goal !set_up_plans
 * Context: true (the plan is always applicable)
 * Body: adds pro-rogue plans for reading the temperature without using a weather station
*/
+!set_up_plans : true
<-
  // removes plans for reading the temperature with the weather station
  .relevant_plans({ +!read_temperature }, _, LL);
  .remove_plan(LL);
  .relevant_plans({ -!read_temperature }, _, LL2);
  .remove_plan(LL2);

  // adds a new plan for reading the temperature that doesn't require contacting the weather station
  // the agent will pick one of the first three temperature readings that have been broadcasted,
  // it will slightly change the reading, and broadcast it
    // adds plan for reading temperature in case fewer than 3 readings have been received
  .add_plan({ +!read_temperature : my_master(Celcius)
    <-
      .print("Rogueing");
      .my_name(N);
      .broadcast(tell, witness_reputation(N, sensing_agent_1, "Don't trust them", -1));
      .broadcast(tell, witness_reputation(N, sensing_agent_2, "Don't trust them", -1));
      .broadcast(tell, witness_reputation(N, sensing_agent_3, "Don't trust them", -1));
      .broadcast(tell, witness_reputation(N, sensing_agent_4, "Don't trust them", -1));
      .broadcast(tell, witness_reputation(N, sensing_agent_5, "Trust Me", 1));
      .broadcast(tell, witness_reputation(N, sensing_agent_6, "Trust Me", 1));
      .broadcast(tell, witness_reputation(N, sensing_agent_7, "Trust Me", 1));
      .broadcast(tell, witness_reputation(N, sensing_agent_8, "Trust Me", 1));
      .broadcast(tell, witness_reputation(N, sensing_agent_9, "Trust Me", 1));
      .broadcast(tell, temperature(Celcius)) });

  // adds plan for reading temperature in case fewer than 3 readings have been received
  .add_plan({ +!read_temperature : true
    <-

    // waits for 2000 milliseconds and finds all beliefs about received temperature readings
    .wait(2000);


    // tries again to "read" the temperature
    !read_temperature }).


/* Import behavior of sensing agent */
{ include("sensing_agent.asl")}

      // picks one of the 3 first received readings randomly
      //.random([0,1,2], SourceIndex);
      //.reverse(TempReadings, TempReadingsReversed)
      //.print("Received temperature readings: ", TempReadingsReversed);
      //.nth(SourceIndex, TempReadingsReversed, Celcius);

      // adds a small deviation to the selected temperature reading
      //.random(Deviation);

      // broadcasts the temperature
      //.print("Read temperature (Celcius): ", Celcius + Deviation);