import numpy
import onnxruntime as rt
from onnxruntime.datasets import get_example

def test():
    print("running simple inference test...")
    example1 = get_example("sigmoid.onnx")
    sess = rt.InferenceSession(example1, providers=rt.get_available_providers())

    input_name = sess.get_inputs()[0].name
    print("input name", input_name)
    input_shape = sess.get_inputs()[0].shape
    print("input shape", input_shape)
    input_type = sess.get_inputs()[0].type
    print("input type", input_type)

    output_name = sess.get_outputs()[0].name
    print("output name", output_name)
    output_shape = sess.get_outputs()[0].shape
    print("output shape", output_shape)
    output_type = sess.get_outputs()[0].type
    print("output type", output_type)

    import numpy.random

    x = numpy.random.random((3, 4, 5))
    x = x.astype(numpy.float32)
    res = sess.run([output_name], {input_name: x})
    print(res)

def main():
    runtimes = ", ".join(rt.get_available_providers())
    print()
    print(f"Available Providers: {runtimes}")
    print()

    test()

if __name__=="__main__":
    main()
