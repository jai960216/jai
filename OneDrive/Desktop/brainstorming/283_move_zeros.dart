class Solution {
  void moveZeroes(List<int> nums) {
    int left = 0;
    for(int right = 0; right < nums.length; right++){
        if (nums[right] != 0){
            int tmp = nums[left];
            nums[left] = nums[right];
            nums[right] = tmp;
            left++;
        }
    }
  }
}