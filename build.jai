// Basic build system, print the binary then exec it

#import "Basic";
#import "Process";
#import "Compiler";

#load "src/source.jai";

main :: () {

  path := defaults.build_path;

  w := compiler_create_workspace();
  if !w {
    print("Workspace creation failed.\n");
    return;
  }

  target_options := get_build_options(w);
  target_options.output_executable_name = path;
  set_build_options(target_options, w);

  compiler_begin_intercept(w);
  // add all the files
  add_build_file(tprint("%/src/main.jai", #filepath), w);  
  while true {
    message := compiler_wait_for_message();
    if !message break;
    if message.kind == {
      case .ERROR {
        print("Build Failed\n");
        break;
      }
      case .COMPLETE;
        run_command(path);
        break;
      }
  }
  compiler_end_intercept(w);
  set_build_options_dc(.{do_output=false});

}