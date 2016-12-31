require "digest"
char_count = 0
count = 0
base = "ojvtpuvg"

password = ["", "", "", "", "", "", "", ""]

loop do
  md5 = Digest::MD5.hexdigest(base + count.to_s)
  if md5[0...5] == "00000"
    position = md5[5].to_i(16)
    if position < 8 && password[position] == ""
      password[position] = md5[6]
      p [md5[5], md5[6]]
      break if password.join.length == 8
    end
  end
  count += 1
end
