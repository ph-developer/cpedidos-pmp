/**
 * The Type enum
 * The domain type is either None, Alphabetic, Numeric or AlphaNumeric
 */
enum SubdomainType {
  None, Alphabetic, Numeric, AlphaNumeric
}

/**
 * The EmailValidator entry point
 * To use the EmailValidator class, call EmailValidator.methodName
 */
export class EmailValidator {
  /**
   * An atomic index which is reused during iterations in different methods
   *
   * @private
   */
  private static index = 0;

  /**
   * A string character set containing all special characters
   *
   * @private
   */
  private static readonly atomCharacters = '!#$%&\'*+-/=?^_`{|}~';

  /**
   * Sets default domainType to null on initialization
   *
   * @private
   */
  private static domainType = SubdomainType.None;

  /**
   * Validate the specified email address.
   *
   * If [allowTopLevelDomains] is `true`, then the validator will
   * allow addresses with top-level domains like `email@example`.
   *
   * If [allowInternational] is `true`, then the validator
   * will use the newer International Email standards for validating
   * the email address.
   *
   * @param email
   * @param allowTopLevelDomains
   * @param allowInternational
   */
  static validate(
    email: string,
    allowTopLevelDomains = false,
    allowInternational = true,
  ): boolean {
    this.index = 0;

    if (email === '' || email.length >= 255) {
      return false;
    }

    // Local-part = Dot-string / Quoted-string
    //       ; MAY be case-sensitive
    //
    // Dot-string = Atom *("." Atom)
    //
    // Quoted-string = DQUOTE *qcontent DQUOTE
    if (email[this.index] === '"') {
      if (!this.skipQuoted(email, allowInternational) || this.index >= email.length) {
        return false;
      }
    } else {
      if (!this.skipAtom(email, allowInternational) || this.index >= email.length) {
        return false;
      }

      while (email[this.index] === '.') {
        this.index += 1;

        if (this.index >= email.length) {
          return false;
        }

        if (!this.skipAtom(email, allowInternational)) {
          return false;
        }

        if (this.index >= email.length) {
          return false;
        }
      }
    }

    if (this.index + 1 >= email.length || this.index > 64 || email[this.index] !== '@') {
      return false;
    }
    this.index += 1;

    if (email[this.index] !== '[') {
      // domain
      if (!this.skipDomain(email, allowTopLevelDomains, allowInternational)) {
        return false;
      }

      return this.index === email.length;
    }

    // address literal
    this.index += 1;

    // we need at least 8 more characters
    if (this.index + 8 >= email.length) {
      return false;
    }

    const ipv6 = email.substring(this.index - 1)
      .toLowerCase();

    if (ipv6.includes('ipv6:')) {
      this.index += 'IPv6:'.length;
      if (!this.skipIPv6Literal(email)) {
        return false;
      }
    } else if (!this.skipIPv4Literal(email)) {
      return false;
    }

    if (this.index >= email.length || email[this.index] !== ']') {
      return false;
    }
    this.index += 1;

    return this.index === email.length;
  }

  /**
   * Returns true if the first letter in string c has a 16-bit UTF-16 code unit
   * greater than or equal to 48 and less than or equal to 57
   * otherwise return false
   *
   * @param c
   * @private
   */
  private static isDigit(c: string): boolean {
    return c.charCodeAt(0) >= 48 && c.charCodeAt(0) <= 57;
  }

  /**
   * Returns true if the first letter in string c has a 16-bit UTF-16 code unit
   * greater than or equal to 65 and less than or equal to 90 (capital letters)
   * or greater than or equal to 97 and less than or equal to 122 (lowercase letters)
   * otherwise return false
   *
   * @param c
   * @private
   */
  private static isLetter(c: string): boolean {
    return (c.charCodeAt(0) >= 65 && c.charCodeAt(0) <= 90)
      || (c.charCodeAt(0) >= 97 && c.charCodeAt(0) <= 122);
  }

  /**
   * Returns true if calling isLetter or isDigit with the same string returns true
   * Only returns false if both isLetter and isDigit return false
   *
   * @param c
   * @private
   */
  private static isLetterOrDigit(c: string): boolean {
    return this.isLetter(c) || this.isDigit(c);
  }

  /**
   * Returns value of allowInternational if the first letter in the string c isnt a
   * number or letter or special character otherwise
   * return the result of _isLetterOrDigit or _atomCharacters.contains(c)
   * which only returns false if both _isLetterOrDigit and _atomCharacters.contains(c)
   * returns false
   *
   * @param c
   * @param allowInternational
   * @private
   */
  private static isAtom(c: string, allowInternational: boolean): boolean {
    return c.charCodeAt(0) < 128
      ? this.isLetterOrDigit(c) || this.atomCharacters.includes(c)
      : allowInternational;
  }

  /**
   * First checks whether the first letter in string c is a letter, number or special
   * character
   * If calling isLetter returns true or c is '-',
   * domainType is set to Alphabetic and the function returns true
   * If calling isDigit returns true
   * domainType is set to Numeric and the function returns true
   * Otherwise the function returns false
   *
   * If the first is statement for string c being a letter, number or special character
   * fails
   * The value of allowInternational is checked where, if true,
   * domainType is set to Alphabetic and the function returns true
   * Otherwise, the function returns false
   *
   * @param c
   * @param allowInternational
   * @private
   */
  private static isDomain(c: string, allowInternational: boolean): boolean {
    if (c.charCodeAt(0) < 128) {
      if (this.isLetter(c) || c === '-') {
        this.domainType = SubdomainType.Alphabetic;
        return true;
      }

      if (this.isDigit(c)) {
        this.domainType = SubdomainType.Numeric;
        return true;
      }

      return false;
    }

    if (allowInternational) {
      this.domainType = SubdomainType.Alphabetic;
      return true;
    }

    return false;
  }

  /**
   * Returns true if domainType is not None
   * Otherwise returns false
   *
   * @param c
   * @param allowInternational
   * @private
   */
  private static isDomainStart(c: string, allowInternational: boolean): boolean {
    if (c.charCodeAt(0) < 128) {
      if (this.isLetter(c)) {
        this.domainType = SubdomainType.Alphabetic;
        return true;
      }

      if (this.isDigit(c)) {
        this.domainType = SubdomainType.Numeric;
        return true;
      }

      this.domainType = SubdomainType.None;

      return false;
    }

    if (allowInternational) {
      this.domainType = SubdomainType.Alphabetic;
      return true;
    }

    this.domainType = SubdomainType.None;

    return false;
  }

  /**
   * TODO: documentation
   *
   * @param text
   * @param allowInternational
   * @private
   */
  private static skipAtom(text: string, allowInternational: boolean): boolean {
    const startIndex = this.index;

    while (this.index < text.length && this.isAtom(text[this.index], allowInternational)) {
      this.index += 1;
    }

    return this.index > startIndex;
  }

  /**
   * Skips checking of subdomain and returns false if domainType is None
   * Otherwise returns true
   *
   * @param text
   * @param allowInternational
   * @private
   */
  private static skipSubDomain(text: string, allowInternational: boolean): boolean {
    const startIndex = this.index;

    if (!this.isDomainStart(text[this.index], allowInternational)) {
      return false;
    }

    this.index += 1;

    while (
      this.index < text.length && this.isDomain(text[this.index], allowInternational)) {
      this.index += 1;
    }

    return (this.index - startIndex) < 64 && text[this.index - 1] !== '-';
  }

  /**
   * Skips checking of domain if domainType is numeric and returns false
   * Otherwise, return true
   *
   * @param text
   * @param allowTopLevelDomains
   * @param allowInternational
   * @private
   */
  private static skipDomain(
    text: string,
    allowTopLevelDomains: boolean,
    allowInternational: boolean,
  ): boolean {
    if (!this.skipSubDomain(text, allowInternational)) {
      return false;
    }

    if (this.index < text.length && text[this.index] === '.') {
      do {
        this.index += 1;

        if (this.index === text.length) {
          return false;
        }

        if (!this.skipSubDomain(text, allowInternational)) {
          return false;
        }
      } while (this.index < text.length && text[this.index] === '.');
    } else if (!allowTopLevelDomains) {
      return false;
    }

    // Note: by allowing AlphaNumeric,
    // we get away with not having to support punycode.
    return this.domainType !== SubdomainType.Numeric;
  }

  /**
   * Function skips over quoted text where if quoted text is in the string
   * the function returns true
   * otherwise the function returns false
   *
   * @param text
   * @param allowInternational
   * @private
   */
  private static skipQuoted(text: string, allowInternational: boolean): boolean {
    let escaped = false;

    // skip over leading '"'
    this.index += 1;

    while (this.index < text.length) {
      if (text[this.index].charCodeAt(0) >= 128 && !allowInternational) {
        return false;
      }

      if (text[this.index] === '\\') {
        escaped = !escaped;
      } else if (!escaped) {
        if (text[this.index] === '"') {
          break;
        }
      } else {
        escaped = false;
      }

      this.index += 1;
    }

    if (this.index >= text.length || text[this.index] !== '"') {
      return false;
    }

    this.index += 1;

    return true;
  }

  /**
   * TODO: documentation
   *
   * @param text
   * @private
   */
  private static skipIPv4Literal(text: string): boolean {
    let groups = 0;

    while (this.index < text.length && groups < 4) {
      const startIndex = this.index;
      let value = 0;

      while (
        this.index < text.length
        && text[this.index].charCodeAt(0) >= 48
        && text[this.index].charCodeAt(0) <= 57
      ) {
        value = (value * 10) + (text[this.index].charCodeAt(0) - 48);
        this.index += 1;
      }

      if (this.index === startIndex || this.index - startIndex > 3 || value > 255) {
        return false;
      }

      groups += 1;

      if (groups < 4 && this.index < text.length && text[this.index] === '.') {
        this.index += 1;
      }
    }

    return groups === 4;
  }

  /**
   * Returns true if the first letter of the string is
   * a,b,c,d,e,f,A,B,C,D,E,F,1,2,3,4,5,6,7,8,9,0
   * otherwise, the function returns false
   *
   * @param str
   * @private
   */
  private static isHexDigit(str: string): boolean {
    const c = str.charCodeAt(0);
    return (c >= 65 && c <= 70)
      || (c >= 97 && c <= 102)
      || (c >= 48 && c <= 57);
  }

  /**
   * This needs to handle the following forms:
   *
   * IPv6-addr = IPv6-full / IPv6-comp / IPv6v4-full / IPv6v4-comp
   * IPv6-hex  = 1*4HEXDIG
   * IPv6-full = IPv6-hex 7(":" IPv6-hex)
   * IPv6-comp = [IPv6-hex *5(":" IPv6-hex)] "::" [IPv6-hex *5(":" IPv6-hex)]
   *             ; The "::" represents at least 2 16-bit groups of zeros
   *             ; No more than 6 groups in addition to the "::" may be
   *             ; present
   * IPv6v4-full = IPv6-hex 5(":" IPv6-hex) ":" IPv4-address-literal
   * IPv6v4-comp = [IPv6-hex *3(":" IPv6-hex)] "::"
   *               [IPv6-hex *3(":" IPv6-hex) ":"] IPv4-address-literal
   *             ; The "::" represents at least 2 16-bit groups of zeros
   *             ; No more than 4 groups in addition to the "::" and
   *             ; IPv4-address-literal may be present
   *
   * @param text
   * @private
   */
  private static skipIPv6Literal(text: string): boolean {
    let compact = false;
    let colons = 0;

    while (this.index < text.length) {
      let startIndex = this.index;

      while (this.index < text.length && this.isHexDigit(text[this.index])) {
        this.index += 1;
      }

      if (this.index >= text.length) {
        break;
      }

      if (this.index > startIndex && colons > 2 && text[this.index] === '.') {
        // IPv6v4
        this.index = startIndex;

        if (!this.skipIPv4Literal(text)) {
          return false;
        }

        return compact ? colons < 6 : colons === 6;
      }

      let count = this.index - startIndex;
      if (count > 4) {
        return false;
      }

      if (text[this.index] !== ':') {
        break;
      }

      startIndex = this.index;
      while (this.index < text.length && text[this.index] === ':') {
        this.index += 1;
      }

      count = this.index - startIndex;
      if (count > 2) {
        return false;
      }

      if (count === 2) {
        if (compact) {
          return false;
        }

        compact = true;
        colons += 2;
      } else {
        colons += 1;
      }
    }

    if (colons < 2) {
      return false;
    }

    return compact ? colons < 7 : colons === 7;
  }
}
