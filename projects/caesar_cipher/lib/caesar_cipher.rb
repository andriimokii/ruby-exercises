def caesar_cipher(string, shift_factor = 0)
  upcase_rotated = ('A'..'Z').to_a.rotate(shift_factor).join
  string.tr('A-Z', upcase_rotated).tr('a-z', upcase_rotated.downcase)
end
