def evaluate_risk(result):

    text = str(result).lower()

    if "headache" in text or "swelling" in text or "swollen" in text:
        return "HIGH RISK"

    if "bleeding" in text or "blood" in text:
        return "EMERGENCY"

    if "blur" in text or "vision" in text or "see properly" in text:
        return "HIGH RISK"

    return "LOW RISK"
