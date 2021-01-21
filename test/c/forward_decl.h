#ifndef __C_TEST_FORWARD_DECL_H__
#define __C_TEST_FORWARD_DECL_H__

// forward decl
struct c_fwdecl_t;

// empty struct
struct c_empty_t{};

// anonymous typedef
typedef struct {
  c_fwdecl_t*  fwdecl;  // a pointer 
} c_has_fwdecl_t;

// forward decl definition
struct c_fwdecl_t{
  int x;
}

#endif // __C_TEST_FORWARD_DECL_H__