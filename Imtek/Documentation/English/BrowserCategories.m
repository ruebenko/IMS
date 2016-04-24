BrowserCategory["IMTEK", None,
{
	Item["Contents", "IMSContentsDocu.nb", IndexTag -> "IMS Contents", CopyTag -> None ],
	BrowserCategory["Introduction", Introduction, {
		Item["Welcome", "IntroImtekDocu.nb", IndexTag -> "IMS Welcome", CopyTag->None],
		Item["License", "LicenseDocu.nb", IndexTag -> "IMS License", CopyTag->None],
		Item["Contributors", "ContributorsDocu.nb", IndexTag -> "IMS Contributors", CopyTag->None],
		Item["Citing IMS", "CitingIMSDocu.nb", IndexTag -> "IMS CitingIMS", CopyTag->None],
		Item["Design Philosophy", "DesignPhilosophyDocu.nb", IndexTag -> "IMS Design Philosophy", CopyTag->None],

		BrowserCategory["Documentation", Documentation, {
			Item["Getting IMS and installation", "InstalationInstructionsIMSDocu.nb", IndexTag -> "IMS GetIMS", CopyTag->None],
			Item["News", "NewsDocu.nb", IndexTag -> "IMS New", CopyTag->None],
			Item["Problems", "ProblemsDocu.nb", IndexTag -> "IMS Problems", CopyTag->None]
		}],

		BrowserCategory["Templates", Templates, {
			Item["Package Template", "PackageTemplateDocu.nb", IndexTag -> "IMS Package Template", CopyTag->None],
			Item["IMTEK Help Style", "ImtekHelpStyleDocu.nb", IndexTag -> "IMS Help Document Style", CopyTag->None],
			Item["IMTEK Browser Index Entry", "BrowserIndexEntryTemplateDocu.nb", IndexTag -> "IMS Browser Index Entry", CopyTag->None]
		}]

	}],

	Item[Delimiter],
	BrowserCategory["Application Examples", ApplicationExamples, {

		BrowserCategory["Electrical Circuits", ElectricalCircuit, {
			Item["Current Controlled Current Source", "CurrentControlledCurrentSourceDocu.nb", IndexTag -> "IMS CurrentControlledCurrentSource", CopyTag->None],
			Item["Diode Characteristic", "DiodeCharacteristicDocu.nb", IndexTag -> "IMS DiodeCharacteristic", CopyTag->None],
			Item["First Order High Pass Filter", "FirstOrderHighPassFilterDocu.nb", IndexTag -> "IMS FirstOrderHighPassFilter", CopyTag->None],
			Item["Second Order Low Pass Filter", "SecondOrderLowPassFilterDocu.nb", IndexTag -> "IMS SecondOrderLowPassFilter", CopyTag->None],
			Item["Transformer", "TransformerDocu.nb", IndexTag -> "IMS Transformer", CopyTag->None],
			Item["Voltage Divider ", "VoltageDividerDocu.nb", IndexTag -> "IMS VoltageDivider", CopyTag->None],
			Item["Wheatstone`s Bridge", "WheatstoneBridgeDocu.nb", IndexTag -> "IMS Wheatstone Bridge", CopyTag->None]
		}],

		BrowserCategory["Finite Element Method", FEM, {
		    Item["Quick Example (Diffusion equation 1D)", "FEMMiniExample1DDocu.nb", IndexTag -> "IMS Quick Example (Diffusion equation 1D)", CopyTag->None],
		    Item["Telegraph Equation 1D", "FEMTelegraphEQN1DDocu.nb", IndexTag -> "IMS Telegraph Equation 1D", CopyTag->None],
		    Item[Delimiter],
		    Item["Quick Example (Heat equation 2D)", "FEMMiniExampleDocu.nb", IndexTag -> "IMS Quick Example (Heat equation 2D)", CopyTag->None],
		    Item["Quick Example (Mixed Elements 2D)", "FEMMixedElementsExampleDocu.nb", IndexTag -> "IMS Quick Example (Mixed Elements 2D)", CopyTag->None],
		    Item["Quick Example (Periodic Boundaries 2D)", "FEMMiniExamplePeriodicBoundariesDocu.nb", IndexTag -> "IMS Quick Example (Periodic Boundaries 2D)", CopyTag->None],
		    Item["Acoustic Eigenmodes (Wave equation 2D)", "AcousticsDocu.nb", IndexTag -> "IMS Acoustic Eigenmodes (Wave equation 2D)", CopyTag->None],
		    Item["Composite Materials (Diffusion equation 2D)", "CompositeMaterialsDocu.nb", IndexTag -> "IMS Composite Materials (Diffusion equation 2D)", CopyTag->None],
		    Item["Convection Diffusion Equation 2D", "AnemometerAnalysisDocu.nb", IndexTag -> "IMS Convection Diffusion Equation 2D", CopyTag->None],
		    Item["Flow around cylinder (Navier-Stokes 2D)", "FlowAroundCylinderDocu.nb", IndexTag -> "IMS Flow around cylinder (Navier-Stokes 2D)", CopyTag->None],
		    Item["Magneto Micro Mover (Diffusion 2D)", "MagnetoMicroMoverDocu.nb", IndexTag -> "IMS Magneto Micro Mover (Diffusion 2D)", CopyTag->None],
		    Item[Delimiter],
		    Item["Composite Materials (Diffusion equation 3D)", "CompositeMaterials3DDocu.nb", IndexTag -> "IMS Composite Materials (Diffusion equation 3D)", CopyTag->None],
		    Item["Electrochemical Reactions (Diffusion 3D)", "ElectroChemicalReactionsDocu.nb", IndexTag -> "IMS Electrochemical Reactions (Diffusion 3D)", CopyTag->None],
		    Item[Delimiter],
		    Item["Quick Example Coupled PDE", "CoupledPDEFEMMiniDocu.nb", IndexTag -> "IMS Quick Example Coupled PDE", CopyTag->None],
		    Item["Structural Mechanics (3D)", "FEMOperatorMechanics3DDocu.nb", IndexTag -> "IMS Structural Mechanics", CopyTag->None],
		    Item[Delimiter],
		    Item["Transient Navier-Stokes (2D)", "NavierStokes2DDocu.nb", IndexTag -> "IMS Transient Navier-Stokes (2D)", CopyTag->None],
		    Item["Free Surface Flow (2D)", "FreeSurfaceFlow2DDocu.nb", IndexTag -> "IMS Free Surface Flow (2D)", CopyTag->None]
		}],

		Item["Graph Elements Library", "GraphElementLibraryDocu.nb", IndexTag -> "IMS Graph Elements Library", CopyTag->None],
		Item["Model Order Reduction", "MORArnoldiVTKDocu.nb", IndexTag -> "IMS Model Order Reduction", CopyTag->None],
	
		BrowserCategory["Simulation Tools", SimulationTools, {
		    Item["SECM", "SECMDocu.nb", IndexTag -> "IMS SECM", CopyTag->None]
		}]
	}],


	BrowserCategory["Lectures and Tips", Lectures, {

		BrowserCategory["Quantum Mechanics", QuantumMechanics, {
			Item["Quantum Mechanics 2", "QuantumMechanicsIIDocu.nb", IndexTag -> "IMS Quantum Mechanics 2", CopyTag->None]
		}],

		BrowserCategory["Simulation I", Simulation1, {
			Item["Derivatives Recovery", "DerivativesDocu.nb", IndexTag -> "IMS Derivatives Recovery", CopyTag->None],
			Item["Finite Difference", "FDM_introDocu.nb", IndexTag -> "IMS Finite Difference", CopyTag->None],
			Item["Finite Volume", "FVM_introDocu.nb", IndexTag -> "IMS Finite Volume", CopyTag->None],
			Item["Finite Elements", "FEM_introDocu.nb", IndexTag -> "IMS Finite Elements", CopyTag->None],
			Item["Iterative Solvers", "IterativeSolversDocu.nb", IndexTag -> "IMS Iterative Solvers", CopyTag->None],
			Item["Multigrid Method", "MultiGrid_introDocu.nb", IndexTag -> "IMS Multigrid Method", CopyTag->None],
			Item["Norms in Analysis", "NormsInAnalysisDocu.nb", IndexTag -> "IMS Norms in Analysis", CopyTag->None],
			Item["Partial Differential Equations (PDEs)", "PDEIntroDocu.nb", IndexTag -> "IMS Partial Differential Equations (PDEs)", CopyTag->None],
			Item["Shape Functions", "ShapeFunction_introDocu.nb", IndexTag -> "IMS Shape Functions", CopyTag->None],
			Item["Sparse Matrices", "SparseMatrixDocu.nb", IndexTag -> "IMS Sparse Matrices", CopyTag->None],
			Item["Stamps for Circuitry", "StampsDocu.nb", IndexTag -> "IMS Stamps for Circuitry", CopyTag->None]
		}],
		(*	
		BrowserCategory["Technical Mechanics", TechnicalMechanics, {
			Item["TMDemos", "DynamicsDemoDriver.nb", IndexTag -> "IMS TMDemos", CopyTag->None]
		}],
		*)
		Item[Delimiter],
		
		BrowserCategory["Mathematica", Mathematica, {
			Item["Graphics and Sounds", "GraphicsSoundsDocu.nb", IndexTag -> "IMS Graphics and Sounds", CopyTag->None],
			Item["Programming for speed", "ProgrammingDocu.nb", IndexTag -> "IMS Programming for speed", CopyTag->None],
			Item["Unsorted", "UnsortedDocu.nb", IndexTag -> "IMS Unsorted", CopyTag->None],
			Item[Delimiter],
			Item["Mathematica Programming Language", "Intro_to_MathematicaDocu.nb", IndexTag -> "IMS Mathematica Programming Language", CopyTag->None],
			Item["Structure and Interpretation of Computer Programs", "msicpDocu.nb", IndexTag -> "IMS Structure and Interpretation of Computer Programs", CopyTag->None]
		}]
	}],

	Item[Delimiter],
	BrowserCategory["Computational Geometry", Packages, {

		BrowserCategory["Geometry", None, {
			Item["LineSegment", "LineSegmentDocu.nb", IndexTag -> "IMS LineSegment", CopyTag->None],
			Item["Point", "PointDocu.nb", IndexTag -> "IMS Point", CopyTag->None],
			Item["Polygon", "PolygonDocu.nb", IndexTag -> "IMS Polygon", CopyTag->None],
			Item["Tetrahedron", "TetrahedronDocu.nb", IndexTag -> "IMS Tetrahedron", CopyTag->None],
			Item["Triangle", "TriangleDocu.nb", IndexTag -> "IMS Triangle", CopyTag->None],
			Item["Voronoi", "VoronoiDocu.nb", IndexTag -> "IMS Voronoi", CopyTag->None]
		}],

		BrowserCategory["Graphs", None, {
			Item["CircuitElementLibrary", "CircuitElementLibraryDocu.nb", IndexTag -> "IMS CircuitElementLibrary", CopyTag->None],
			Item["DomainElementLibrary", "DomainElementLibraryDocu.nb", IndexTag -> "IMS DomainElementLibrary", CopyTag->None],
			Item["Graph", "GraphDocu.nb", IndexTag -> "IMS Graph", CopyTag->None],
			Item["MeshElementLibrary", "MeshElementLibraryDocu.nb", IndexTag -> "IMS MeshElementLibrary", CopyTag->None],
			Item["Nodes", "NodesDocu.nb", IndexTag -> "IMS Nodes", CopyTag->None]
		}],

		BrowserCategory["Meshes", None, {
			Item["Mesher Utilities", "MesherUtilitiesDocu.nb", IndexTag -> "IMS MesherUtilities", CopyTag->None],
			Item["Structured Mesher", "StructuredMesherDocu.nb", IndexTag -> "IMS StructuredMesher", CopyTag->None]
		}],

		BrowserCategory["Solid Modelling", None, {
			Item["Process Emulate", "ProcessEmulateDocu.nb", IndexTag -> "IMS ProcessEmulate", CopyTag->None]
		}]
	}],

	BrowserCategory["Data Structures", Packages, {
		Item["Queue", "QueueDocu.nb",  IndexTag -> "IMS Queue", CopyTag->None],
		Item["Trees", "TreesDocu.nb",  IndexTag -> "IMS Trees", CopyTag->None]
	}],

	BrowserCategory["Differential Equation Systems", Packages, { 

		BrowserCategory["Discretization", None, {
			Item["Finite Element Fluidics", "FEMFluidicsDocu.nb", IndexTag -> "IMS FEMFluidics", CopyTag->None],
			Item["Finite Element Mechanics", "FEMMechanicsDocu.nb", IndexTag -> "IMS FEMMechanics", CopyTag->None],
			Item["Finite Element Operators", "FEMOperatorsDocu.nb", IndexTag -> "IMS FEMOperators", CopyTag->None],
			Item["Finite Difference Navier-Stokes Solver", "FDMNavierStokesDocu.nb", IndexTag -> "IMS FDMNavierStokes", CopyTag->None],
			Item["Geometric Finite Difference", "GeometricFDMSolverDocu.nb",  IndexTag -> "IMS GeometricFDMSolver", CopyTag->None],
			Item["Lumped Systems", "LumpedSystemDocu.nb",  IndexTag -> "IMS LumpedSystem", CopyTag->None]
		}],


		BrowserCategory["Model Order Reduction", None , {
			Item["Arnoldi", "ArnoldiDocu.nb", IndexTag -> "IMS Arnoldi",  CopyTag->None],
			Item["MORTools", "MORToolsDocu.nb", IndexTag -> "IMS MORTools",  CopyTag->None],
			Item["Parametric Reduction", "ParametricReductionDocu.nb",  IndexTag -> "IMS ParametricReduction", CopyTag->None],
			Item["Postprocess MOR", "Post4MORDocu.nb", IndexTag -> "IMS PostprocessMOR",  CopyTag->None]
		}],

		BrowserCategory["Solver", None, {
			Item["Multigrid", "MultiGridDocu.nb", IndexTag -> "IMS Multigrid",  CopyTag->None],
			Item["Algebraic Solver", "AlgebraicSolverDocu.nb",  IndexTag -> "IMS AlgebraicSolver",CopyTag->None]
		}],

		BrowserCategory["System Theory", None, {
			Item["Backward Difference Formulae (BDF)", "BDFDocu.nb", IndexTag -> "IMS BDF",  CopyTag->None],
			Item["System", "SystemDocu.nb", IndexTag -> "IMS System",  CopyTag->None],
			Item["System Analysis", "SystemAnalysisDocu.nb", IndexTag -> "IMS SystemAnalysis", CopyTag->None],
			Item["Timeintegration of Systems", "TimeIntegrateDocu.nb", IndexTag -> "IMS TimeIntegrate", CopyTag->None]
		}],


		BrowserCategory["Utilities", None, {
			Item["Area Coordinates", "AreaCoordinatesDocu.nb", IndexTag -> "IMS AreaCoordinates",  CopyTag->None],
			Item["Assembler", "AssemblerDocu.nb", IndexTag -> "IMS Assembler",  CopyTag->None],
			Item["Boundary Conditions", "BoundaryConditionsDocu.nb", IndexTag ->"IMS BoundaryConditions", CopyTag->None],
			Item["Coupled PDEs", "CoupledPDEsDocu.nb",  IndexTag->"IMS CoupledPDEs", CopyTag -> None],
			Item["Interpolation", "InterpolationDocu.nb", IndexTag -> "IMS Interpolation",  CopyTag->None],
			Item["Nonlinear Solve", "NonlinearSolveDocu.nb",  IndexTag->"IMS NonlinearSolve", CopyTag -> None],
			Item["Nonlinear PDE", "NonlinearPDEDocu.nb",  IndexTag->"IMS NonlinearPDE", CopyTag -> None],
			Item["Norms", "NormsDocu.nb", IndexTag -> "IMS Norms",  CopyTag->None],
			Item["Numerical Integration", "NumericalIntegrationDocu.nb", IndexTag -> "IMS NumericalIntegration", CopyTag->None],
			Item["OdeUtils", "OdeUtilsDocu.nb", IndexTag -> "IMS OdeUtils",  CopyTag->None],
			Item["Operator Utilities", "OperatorUtilitiesDocu.nb", IndexTag -> "IMS OperatorUtilities", CopyTag->None],
			Item["Shape Functions", "ShapeFunctionsDocu.nb", IndexTag -> "IMS ShapeFunctions", CopyTag->None],
			Item["SparseUtils", "SparseUtilsDocu.nb", IndexTag -> "IMS SparseUtils",  CopyTag->None]
		}]
	}],

	BrowserCategory["Game Theory", Packages, {
		Item["Exact Cover", "ExactCoverDocu.nb", IndexTag -> "IMS ExactCover",  CopyTag->None],
		Item["Sudoku", "SudokuDocu.nb", IndexTag -> "IMS Sudoku",  CopyTag->None]
	}],

	BrowserCategory["Utlities", Packages, {
		
		BrowserCategory["Computational", None, {
			Item["Extended Timing", "ExtendedTimingDocu.nb", IndexTag -> "IMS ExtendedTiming",  CopyTag->None],
			Item["Show Status", "ShowStatusDocu.nb", IndexTag -> "IMS ShowStatus",  CopyTag->None]
		}],

		BrowserCategory["Language", None, {
			Item["Language Extension", "LanguageExtensionDocu.nb", IndexTag -> "IMS LanguageExtension",  CopyTag->None]
		}],

		BrowserCategory["Graphics", None , {
			Item["Graphics3D", "Graphics3DDocu.nb", IndexTag -> "IMS Graphics3D",  CopyTag->None],
			Item["Shape Containment", "ShapeContainmentDocu.nb", IndexTag -> "IMS ShapeContainment",  CopyTag->None],
			Item["Unstructured Plot", "UnstructuredPlotDocu.nb",  IndexTag -> "IMS UnstructuredPlot", CopyTag->None],
			Item["Voxel Graphics", "VoxelDocu.nb",  IndexTag -> "IMS Voxel", CopyTag->None]
		}],
		
		BrowserCategory["Physics", None , {
			Item["Diamond structures", "DiamondDocu.nb", IndexTag -> "IMS Diamond", CopyTag->None],
			Item["Material Database", "MaterialDatabaseDocu.nb", IndexTag -> "IMS MaterialDatabase", CopyTag->None],
			Item["Polarisation", "PolarisationDocu.nb", IndexTag -> "IMS Polarisation",  CopyTag->None]
		}]

	}],
	
	Item[Delimiter],	
	BrowserCategory["Interfaces", Interfaces, {
		Item["3D-Studio", "Read3dsDocu.nb", IndexTag -> "IMS 3D-Studio", CopyTag->None],
		Item["Ansys", "AnsysDocu.nb", IndexTag -> "IMS Ansys", CopyTag->None],
		Item["Ansys Element Matrix", "AnsysEmatDocu.nb", IndexTag -> "IMS AnsysElementMatrix", CopyTag->None],
		Item["Ansys Records", "AnsysRecordsDocu.nb", IndexTag -> "IMS AnsysRecords", CopyTag->None],
		Item["ATLAS", "MathLibDevCon2003Docu.nb", IndexTag -> "IMS ATLAS", CopyTag->None],
		Item["COMSOL", "COMSOLDocu.nb", IndexTag -> "IMS COMSOL", CopyTag->None],
		Item["EasyMesh", "EasyMeshDocu.nb", IndexTag -> "IMS EasyMesh", CopyTag->None],
		Item["EasyMesh Plotting", "EasymeshPlottingDocu.nb", IndexTag -> "IMS EasymeshPlotting", CopyTag->None],
	(*	Item["Miffer", "MifferDocu.nb", IndexTag -> "IMS Miffer", CopyTag->None],
		Item["Ply2", "Ply2Docu.nb", IndexTag -> "IMS Ply2", CopyTag->None], *)
		Item["HDLExport", "HDLExportDocu.nb", IndexTag -> "IMS HDLExport", CopyTag->None],
		Item["QHull", "QHullInterfaceDocu.nb", IndexTag -> "IMS QHullInterface", CopyTag->None],
		Item["TetgenInterface", "TetgenInterfaceDocu.nb", IndexTag -> "IMS TetgenInterface", CopyTag->None],
		Item["TriangleInterface", "TriangleInterfaceDocu.nb", IndexTag -> "IMS TriangleInterface", CopyTag->None],
		Item["VTK", "VTKDocu.nb", IndexTag -> "IMS VTK", CopyTag->None]
	}],

	Item[Delimiter],
       	BrowserCategory["IMS and Maintenance", Packages, {
		Item["Debug", "DebugDocu.nb", IndexTag -> "IMS Debug",  CopyTag->None],
		Item["IMS", "IMSDocu.nb", IndexTag -> "IMS IMS",  CopyTag->None],
		Item["IMS to HTML converter ", "IMSHTMLConverterDocu.nb", IndexTag -> "IMS HTMLConverter",  CopyTag->None],
               	Item["Maintenance", "MaintenanceDocu.nb", IndexTag -> "IMS Maintenance", CopyTag->None]
       	}],

	Item[Delimiter],
	BrowserCategory["Foreign", Foreign, {
		BrowserCategory["Tutorials", Tutorials, {
			Item["Graphics Tricks", "GraphicsTricks.nb", IndexTag -> "Ersek GraphicsTricks", CopyTag->None],
			Item["Tricks", "Tricks.nb", IndexTag -> "Ersek Tricks", CopyTag->None]
		}]
	}]

}]
