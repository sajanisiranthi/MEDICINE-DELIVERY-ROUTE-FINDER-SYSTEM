💊 Medicine Delivery Route Finder System

AI-Based Route Planning Using Prolog

📌 Project Overview

The Medicine Delivery Route Finder System is an Artificial Intelligence mini project developed for the COU4303 – Artificial Intelligence course of the BSc (IT) Degree Programme at the Open University of Sri Lanka (OUSL).

This system finds routes from a central medicine warehouse to pharmacies using AI search algorithms. It models road connections, distances, and blocked roads to demonstrate route planning in a medicine delivery environment.

🎯 Objectives

Find valid routes between the warehouse and pharmacies.

Implement DFS, BFS, and A* search algorithms.

Avoid specified blocked roads.

Calculate total route distances.

Compare the behaviour of different search algorithms.

🛠️ Technologies Used

Language: Prolog

Environment: SWI-Prolog

Version Control: Git and GitHub

📍 System Locations

The system contains one medicine warehouse and ten pharmacies.

Medicine Warehouse (Malkaduwawa)

Kurunegala Pharmacy

Dambadeniya Pharmacy

Kuliyapitiya Pharmacy

Nikaweratiya Pharmacy

Galgamuwa Pharmacy

Wariyapola Pharmacy

Melsiripura Pharmacy

Mawathagama Pharmacy

Polgahawela Pharmacy

Yapahuwa Pharmacy

🧠 Search Algorithms

1. Depth-First Search (DFS)

Explores one path deeply before backtracking to find another possible route.

2. Breadth-First Search (BFS)

Explores locations level by level and finds a path with the fewest edges in an unweighted graph.

3. A* Search

Uses actual path cost and a heuristic estimate to guide the search.

Evaluation Function:

f(n) = g(n) + h(n)

g(n) – Actual distance travelled.

h(n) – Estimated remaining distance.

f(n) – Estimated total route cost.

🚧 Blocked Roads

The system excludes the following connections from route searching:

Medicine Warehouse – Yapahuwa

Polgahawela – Kuliyapitiya

Medicine Warehouse – Dambadeniya

This feature demonstrates how road restrictions can influence route planning.

⚙️ How It Works

Load the location and road information.

Select the starting location and destination.

Check road connections and blocked roads.

Execute the selected search algorithm.

Find a valid route and calculate its distance.

Compare algorithm results where supported.

🚀 Future Improvements

Real-time traffic information.

GPS and digital map integration.

Graphical user interface.

Multiple pharmacy delivery optimisation.

Database integration.

👥 Project Information

Course: COU4303 – Artificial Intelligence

Degree: BSc (IT)

Institution: Open University of Sri Lanka

Group Number: 14
