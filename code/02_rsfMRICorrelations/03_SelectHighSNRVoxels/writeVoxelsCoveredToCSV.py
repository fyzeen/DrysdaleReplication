# importing modules
import pandas as pd
import argparse

def append_to_csv(file_path, value1, value2, value3, value4, value5):
    # Create a DataFrame with the values to be appended
    data = pd.DataFrame([[value1, value2, value3, value4, value5]])

    # Append the DataFrame to the CSV file
    data.to_csv(file_path, mode='a', header=False, index=False)

    return

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Saves inputted values to a row in a csv (in this case, used to save voxel coverage)")
    parser.add_argument("out_path", type=str, help="Enter EXISTING .csv file to which you want to append the values")
    parser.add_argument("value1", type=int)
    parser.add_argument("value2", type=int)
    parser.add_argument("value3", type=int)
    parser.add_argument("value4", type=int)
    parser.add_argument("value5", type=int)
    args = parser.parse_args()

    append_to_csv(args.out_path, args.value1, args.value2, args.value3, args.value4, args.value5)

    