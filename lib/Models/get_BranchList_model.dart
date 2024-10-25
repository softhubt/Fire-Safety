  import 'dart:convert';

  GetBranchList getBranchListFromJson(String str) =>
      GetBranchList.fromJson(json.decode(str));

  String getBranchListToJson(GetBranchList data) =>
      json.encode(data.toJson());

  class GetBranchList {
    String? statusCode;
    String? message;
    List<BranchListItem>? branchList;

    GetBranchList({
      this.statusCode,
      this.message,
      this.branchList,
    });

    factory GetBranchList.fromJson(Map<String, dynamic> json) {
      return GetBranchList(
        statusCode: json["status_code"],
        message: json["message"],
        branchList: json["branch_list"] != null
            ? List<BranchListItem>.from(
            json["branch_list"].map((x) => BranchListItem.fromJson(x)))
            : null,
      );
    }

    Map<String, dynamic> toJson() => {
      "status_code": statusCode,
      "message": message,
      "branch_list": branchList != null
          ? List<dynamic>.from(branchList!.map((x) => x.toJson()))
          : null,
    };
  }

  class BranchListItem {
    String? id;
    String? branch;

    BranchListItem({
      this.id,
      this.branch,
    });

    factory BranchListItem.fromJson(Map<String, dynamic> json) =>
        BranchListItem(
          id: json["id"],
          branch: json["branch"],
        );

    Map<String, dynamic> toJson() => {
      "id": id,
      "branch": branch,
    };
  }
