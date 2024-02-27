#include "jlcxx/jlcxx.hpp"
#include "include/libacc/bvh_tree.h"
// #include "include/libacc/kd_tree.h"
#include "vector.h"

// TODO: use double maybe
typedef math::Vec3f Vec3f;

typedef acc::BVHTree<unsigned int, Vec3f> ACC_BVHTree;

struct BVHTree {
  ACC_BVHTree tree;
  BVHTree(jlcxx::ArrayRef<unsigned int> faces, jlcxx::ArrayRef<math::Vec3f> vertices): 
    tree(std::vector<unsigned int>(faces.begin(), faces.end()), std::vector<Vec3f>(vertices.begin(), vertices.end())) {}

  float intersect(Vec3f origin, Vec3f direction, const float tmax=10000.0f) {
    ACC_BVHTree::Ray ray;
    ray.origin = origin;
    ray.dir = direction;
    ray.tmin = 0.0f;
    ray.tmax = tmax;

    ACC_BVHTree::Hit hit;
    if (tree.intersect(ray, &hit)) {
      return hit.t;
    }
    return -1.0f;
  }
  Vec3f closest_point(Vec3f vertex) {
    return tree.closest_point(vertex);
  }
};

// not working because they include a math lib we do not have
// typedef acc::KDTree<3> ACC_KDTree;
// struct KDTree {
//   ACC_KDTree tree;
//   KDTree(jlcxx::ArrayRef<math::Vec3f> vertices): tree(std::vector<Vec3f>(vertices.begin(), vertices.end())) {}
//   Vec3f find_nn(Vec3f vertex) {
//     std::pair<unsigned int, float> result;
//     tree.find_nn(vertex, &result); 
//     return tree.vertices[result.first];
//   }
// }


JLCXX_MODULE define_julia_module(jlcxx::Module& mod)
{
  mod.add_type<Vec3f>("Vec3f")
    .constructor<float, float, float>()
    .method("data", [](Vec3f& v) { return jlcxx::make_julia_array(v.begin(), 3); })
    .method("get", [](Vec3f const& v, unsigned int i) { return v[i]; });
  mod.add_type<BVHTree>("BVHTree")
    .constructor<jlcxx::ArrayRef<unsigned int>, jlcxx::ArrayRef<math::Vec3f>>()
    .method("intersect", &BVHTree::intersect)
    .method("closest_point", &BVHTree::closest_point);
  // mod.add_type<KDTree>("KDTree")
  //   .constructor<jlcxx::ArrayRef<math::Vec3f>>()
  //   .method("find_nn", &KDTree::find_nn);
}
