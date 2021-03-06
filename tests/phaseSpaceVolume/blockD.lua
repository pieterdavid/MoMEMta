load_modules('MatrixElements/dummy/libme_dummy.so')

M_W = 250.
M_TOP = 500.
W_W = 10000.
W_TOP = 10000.

configuration = {
    energy = 1000.,
    top_mass = M_TOP,
    W_mass = M_W
}

vegas = {
    verbosity = 2,
    max_eval = 1000000,
    relative_accuracy = 0.01,
    n_increase = 25000,
}

-- 'Flat' transfer functions to integrate over the visible particle's energies and angles
-- First |P|
FlatTransferFunctionOnP.tf_p_1 = {
    ps_point = 'cuba::ps_points/0',
    reco_particle = 'input::particles/0',
    min = 0.,
    max = configuration.energy,
}
FlatTransferFunctionOnP.tf_p_2 = {
    ps_point = 'cuba::ps_points/1',
    reco_particle = 'input::particles/1',
    min = 0.,
    max = configuration.energy,
}
FlatTransferFunctionOnP.tf_p_3 = {
    ps_point = 'cuba::ps_points/2',
    reco_particle = 'input::particles/2',
    min = 0.,
    max = configuration.energy,
}
FlatTransferFunctionOnP.tf_p_4 = {
    ps_point = 'cuba::ps_points/3',
    reco_particle = 'input::particles/3',
    min = 0.,
    max = configuration.energy,
}

-- Pass these outputs over for Phi
FlatTransferFunctionOnPhi.tf_phi_1 = {
    ps_point = 'cuba::ps_points/4',
    reco_particle = 'tf_p_1::output',
}
FlatTransferFunctionOnPhi.tf_phi_2 = {
    ps_point = 'cuba::ps_points/5',
    reco_particle = 'tf_p_2::output',
}
FlatTransferFunctionOnPhi.tf_phi_3 = {
    ps_point = 'cuba::ps_points/6',
    reco_particle = 'tf_p_3::output',
}
FlatTransferFunctionOnPhi.tf_phi_4 = {
    ps_point = 'cuba::ps_points/7',
    reco_particle = 'tf_p_4::output',
}

-- Finally, do Theta 
FlatTransferFunctionOnTheta.tf_theta_1 = {
    ps_point = 'cuba::ps_points/8',
    reco_particle = 'tf_phi_1::output',
}
FlatTransferFunctionOnTheta.tf_theta_2 = {
    ps_point = 'cuba::ps_points/9',
    reco_particle = 'tf_phi_2::output',
}
FlatTransferFunctionOnTheta.tf_theta_3 = {
    ps_point = 'cuba::ps_points/10',
    reco_particle = 'tf_phi_3::output',
}
FlatTransferFunctionOnTheta.tf_theta_4 = {
    ps_point = 'cuba::ps_points/11',
    reco_particle = 'tf_phi_4::output',
}

inputs = {
  'tf_theta_1::output',
  'tf_theta_2::output',
  'tf_theta_3::output',
  'tf_theta_4::output',
}

Flatter.flatter_s13 = {
    input = "cuba::ps_points/12",
    mass = M_W,
    width = W_W
}

Flatter.flatter_s134 = {
    input = "cuba::ps_points/13",
    mass = M_TOP,
    width = W_TOP
}

Flatter.flatter_s25 = {
    input = "cuba::ps_points/14",
    mass = M_W,
    width = W_W
}

Flatter.flatter_s256 = {
    input = "cuba::ps_points/15",
    mass = M_TOP,
    width = W_TOP
}

BlockD.blockd = {
    inputs = inputs,

    s13 = 'flatter_s13::s',
    s134 = 'flatter_s134::s',
    s25 = 'flatter_s25::s',
    s256 = 'flatter_s256::s',
}

Boost.boost = {
    invisibles = {
        'blockd::invisibles',
    },

    particles = inputs
}

jacobians = {
  'tf_p_1::TF_times_jacobian', 'tf_p_2::TF_times_jacobian', 'tf_p_3::TF_times_jacobian', 'tf_p_4::TF_times_jacobian', 
  'tf_phi_1::TF_times_jacobian', 'tf_phi_2::TF_times_jacobian', 'tf_phi_3::TF_times_jacobian', 'tf_phi_4::TF_times_jacobian', 
  'tf_theta_1::TF_times_jacobian', 'tf_theta_2::TF_times_jacobian', 'tf_theta_3::TF_times_jacobian', 'tf_theta_4::TF_times_jacobian', 
  'flatter_s13::jacobian', 'flatter_s134::jacobian', 'flatter_s25::jacobian', 'flatter_s256::jacobian'
}

MatrixElement.dummy = {
  use_pdf = false,

  matrix_element = 'dummy_matrix_element',
  matrix_element_parameters = {},

  initialState = 'boost::output',

  invisibles = {
    input = 'blockd::invisibles',
    jacobians = 'blockd::jacobians',
    ids = {
      {
        pdg_id = 0,
        me_index = 1,
      },

      {
        pdg_id = 0,
        me_index = 2,
      }
    }
  },

  particles = {
    inputs = inputs,
    ids = {
      {
        pdg_id = 0,
        me_index = 3,
      },

      {
        pdg_id = 0,
        me_index = 4,
      },

      {
        pdg_id = 0,
        me_index = 5,
      },

      {
        pdg_id = 0,
        me_index = 6,
      },
    }
  },

  jacobians = jacobians
}
