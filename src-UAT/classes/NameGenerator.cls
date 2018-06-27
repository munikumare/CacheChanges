public with sharing class NameGenerator {
	@InvocableMethod(label='Generate Name')
	public static List<String> getName(List<String> prefix){
		return new List<String>{ generate(prefix[0]) };
	}
	public static String generate(String prefix){
		String timeStamp = Datetime.Now().format('YYYYMMdd_hhmmss a z');
		String lastName = userInfo.getLastName();
		Integer nameLimit = Math.round((80 - 24 - prefix.length()))-1;
		String trimmedLastName = lastName.length()>nameLimit? lastName.substring(0,nameLimit) : lastName;
		String name = prefix +'_'+  trimmedLastName + '_' + timeStamp;
		return name;
	}
}