Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc250.phx1.oracleemaildelivery.com (aib29ajc250.phx1.oracleemaildelivery.com [192.29.103.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2582AC77B6E
	for <ocfs2-devel@archiver.kernel.org>; Tue,  4 Apr 2023 17:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=fC6aGb5g6+5DQ7T+a7jOmu4RWrrDpiF7U5VB6ylt7l4=;
 b=lMQ9zFNgue4EZuOOX28ZcQOG/LuVdyluzHL6/8vOk9osQhG7tj1GsTJ/64vuXePX5QHZWfmUt0us
   a1P7ijg5BiXVa/QOBtDyKEIXF1BwHENTHqA4ncoSWJ0Mhw6YQCKu1H9mbJmEMJ1Br92ty4yu0Py3
   9j1rwooeG0aX1MDRcyGD3nt60sDply0dMYrY3h1QjQrlf+Ut5oNeaIECxmXkKvbuXWYMa0hEbiAe
   0lFKLYR6wa3wNjRZgbVMK5gR4yIuYi82jUDB6QPlk396rhi/eK0MpthnT4Jo1gPEBobqYujVc+zZ
   70SQIN+o0qmO3yawar3wwpaCe438PlA+vL+i4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=fC6aGb5g6+5DQ7T+a7jOmu4RWrrDpiF7U5VB6ylt7l4=;
 b=A/9qR+58EuhScKZrSjGJZVs2KDkx2/uGfRDNeba+SVCMUK2tNnPj4Dx/fkI+7/c9Cp5QLFfJlViu
   E8/Gnzmk2d8iIlhTj7Q+9WuHm3vJr/ATB6YWFhvJci4YkH60kae0VcBdNKx4HuwPz9S6YHWwy4Rh
   pJ7GzMCdHy0cyBsruz9g1ti/nBkglB/LVAXpNvuXKCJf9pJDCwwdX65z9MmNqfR8saumXZE06VFd
   y4GdgSk6D5q3dHKUHVa535xiQZLEXq0IHViwEDkykaq1bfkrnVa2DuxFt5qRKxnX5i7Nzr9wgZTp
   64SCALlzkYN0GV3kdGMlsAVP/yP3al4LCAZ/UQ==
Received: by omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20230317 64bit (built Mar 17
 2023))
 with ESMTPS id <0RSL00OKZPOUTAD0@omta-ad2-fd3-201-us-phoenix-1.omtaad2.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Tue, 04 Apr 2023 17:24:30 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org; s=k20201202;
 t=1680628473; bh=FsOURgAMeOOBIuj2i3uw5Po7ucebRoFXj4YCGwVLrvI=;
 h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
 b=I7N7ZAy1EBEGmuQpK02HSlrey0IX0hh4XCm3MzD1kWYS874FTk0I+jc4w7hH3N4sr
 nopeVd/YVeuILyqiVn2/ekRTuSLgDNpwDZ+C9maHwxxe+JUTqbSPGQgHlW5Gdhy3vX
 oq3RR271cLZ9FnQDLswxrl+GgpPavc1+jpWlZVmrfurz/EQ4YBVrPDwDTS9JiI3XrY
 6hcdooPFrWqMT2i2k+eCJ+zcTf2dWDJTXbKwiovKHQM3wi9z5U262EUVQx0/M+wfZd
 nCS4PJ10VfML64nfyxeFEX36paSGBSjUek8e5KcPzvRDfjBaft6o8cijLpO9UleHpX
 OPw5Tsq+IRTQg==
To: fstests@vger.kernel.org
Date: Wed,  5 Apr 2023 01:14:08 +0800
Message-id: <20230404171411.699655-3-zlang@kernel.org>
X-Mailer: git-send-email 2.39.2
In-reply-to: <20230404171411.699655-1-zlang@kernel.org>
References: <20230404171411.699655-1-zlang@kernel.org>
MIME-version: 1.0
X-Source-IP: 139.178.84.217
X-Proofpoint-Virus-Version: vendor=nai engine=6500 definitions=10670
 signatures=596816
Cc: brauner@kernel.org, linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org,
 ebiggers@google.com, amir73il@gmail.com, linux-unionfs@vger.kernel.org,
 anand.jain@oracle.com, linux-f2fs-devel@lists.sourceforge.net,
 linux-xfs@vger.kernel.org, fdmanana@suse.com, ocfs2-devel@oss.oracle.com,
 jack@suse.com, linux-fsdevel@vger.kernel.org, ceph-devel@vger.kernel.org,
 linux-ext4@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: [Ocfs2-devel] [PATCH 2/5] tools/get_maintainer.pl: remove penguin
	chiefs
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Zorro Lang via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Zorro Lang <zlang@kernel.org>
Content-type: text/plain; charset="us-ascii"
Content-transfer-encoding: 7bit
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-ServerName: dfw.source.kernel.org
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 include:_spf.kernel.org ~all
X-Proofpoint-Spam-Reason: safe
X-Spam: OrgSafeList
X-SpamRule: orgsafelist
X-Proofpoint-ORIG-GUID: gF-GoIxUs88ebDuuq6XM6L2uVkjeaGXN
X-Proofpoint-GUID: gF-GoIxUs88ebDuuq6XM6L2uVkjeaGXN
X-Mailman-Approved-At: Tue, 04 Apr 2023 17:24:27 +0000
Reporting-Meta:
 AAEi0pgg31U6IlAG/Qhj2U1a239IGqCloK9GKPYlA+smqVUcU8Yz+iArp6Bd+0jw
 gnQM/cGSLIW3wJ5tibir40Dmf0BYBo/iPE9ytU+nKL5NZuj9rJWe/J1mfpcjF1UG
 QjD5lBa3Sa6U/YJ1G6+bFqYPCYpuzLBDOI7LglQ3qY7DI/xo7DWpjWjJfd1nbt1m
 5dBGDWD7AKQ8tnpniCJeT1847El6mLx+bNz90Tq4lW1X0x379fePPwIncXXMroKy
 u+k0PMtU56O20dDEkJlwibLFHDmst85o/X0cHkHYEGhsg3I7qsnvDEs0mq89K3mj
 vpmqX8mhMYU2FOexq4WBlTGqL08d6qc6idd77kheWmda/o3Q7YWF2FGaLJiK/dcZ
 gE3Ytsp2fpfbY52pmGOV35tfJpiflbqxoGOxFSyzdvanzP4BVb7FjLpMMYHD0Qvx
 6xMUY4tgEDxo4ZN/GKxCyA5tzZwCIpE6gO7MqZSgNAQ5StFiP3ppFpVzpan/GZMj
 6NupN8b7vYcgxoReCo3O1j/h9JN4ZAxolNEXiCaShFhX

There's not penguin chiefs in fstests, so remove related code.

Signed-off-by: Zorro Lang <zlang@kernel.org>
---
 tools/get_maintainer.pl | 45 +----------------------------------------
 1 file changed, 1 insertion(+), 44 deletions(-)

diff --git a/tools/get_maintainer.pl b/tools/get_maintainer.pl
index 376c7c02..671ffe26 100755
--- a/tools/get_maintainer.pl
+++ b/tools/get_maintainer.pl
@@ -31,7 +31,6 @@ my $email_fixes = 1;
 my $email_list = 1;
 my $email_moderated_list = 1;
 my $email_subscriber_list = 0;
-my $email_git_penguin_chiefs = 0;
 my $email_git = 0;
 my $email_git_all_signature_types = 0;
 my $email_git_blame = 0;
@@ -79,19 +78,6 @@ my @file_emails = ();
 my %commit_author_hash;
 my %commit_signer_hash;
 
-my @penguin_chief = ();
-push(@penguin_chief, "Zorro Lang:zlang\@kernel.org");
-
-my @penguin_chief_names = ();
-foreach my $chief (@penguin_chief) {
-    if ($chief =~ m/^(.*):(.*)/) {
-	my $chief_name = $1;
-	my $chief_addr = $2;
-	push(@penguin_chief_names, $chief_name);
-    }
-}
-my $penguin_chiefs = "\(" . join("|", @penguin_chief_names) . "\)";
-
 # Signature types of people who are either
 # 	a) responsible for the code in question, or
 # 	b) familiar enough with it to give relevant feedback
@@ -242,7 +228,6 @@ if (!GetOptions(
 		'git-blame!' => \$email_git_blame,
 		'git-blame-signatures!' => \$email_git_blame_signatures,
 		'git-fallback!' => \$email_git_fallback,
-		'git-chief-penguins!' => \$email_git_penguin_chiefs,
 		'git-min-signatures=i' => \$email_git_min_signatures,
 		'git-max-maintainers=i' => \$email_git_max_maintainers,
 		'git-min-percent=i' => \$email_git_min_percent,
@@ -327,7 +312,7 @@ if ($sections || $letters ne "") {
 if ($email &&
     ($email_maintainer + $email_reviewer +
      $email_list + $email_subscriber_list +
-     $email_git + $email_git_penguin_chiefs + $email_git_blame) == 0) {
+     $email_git + $email_git_blame) == 0) {
     die "$P: Please select at least 1 email option\n";
 }
 
@@ -967,19 +952,6 @@ sub get_maintainers {
     }
 
     if ($email) {
-	foreach my $chief (@penguin_chief) {
-	    if ($chief =~ m/^(.*):(.*)/) {
-		my $email_address;
-
-		$email_address = format_email($1, $2, $email_usename);
-		if ($email_git_penguin_chiefs) {
-		    push(@email_to, [$email_address, 'chief penguin']);
-		} else {
-		    @email_to = grep($_->[0] !~ /${email_address}/, @email_to);
-		}
-	    }
-	}
-
 	foreach my $email (@file_emails) {
 	    $email = mailmap_email($email);
 	    my ($name, $address) = parse_email($email);
@@ -1041,7 +1013,6 @@ MAINTAINER field selection options:
     --git-all-signature-types => include signers regardless of signature type
         or use only ${signature_pattern} signers (default: $email_git_all_signature_types)
     --git-fallback => use git when no exact MAINTAINERS pattern (default: $email_git_fallback)
-    --git-chief-penguins => include ${penguin_chiefs}
     --git-min-signatures => number of signatures required (default: $email_git_min_signatures)
     --git-max-maintainers => maximum maintainers to add (default: $email_git_max_maintainers)
     --git-min-percent => minimum percentage of commits required (default: $email_git_min_percent)
@@ -1289,8 +1260,6 @@ sub get_maintainer_role {
 	$role = "orphan minder";
     } elsif ($role eq "obsolete") {
 	$role = "obsolete minder";
-    } elsif ($role eq "buried alive in reporters") {
-	$role = "chief penguin";
     }
 
     return $role . ":" . $subsystem;
@@ -1607,10 +1576,6 @@ sub vcs_find_signers {
     save_commits_by_author(@lines) if ($interactive);
     save_commits_by_signer(@lines) if ($interactive);
 
-    if (!$email_git_penguin_chiefs) {
-	@signatures = grep(!/${penguin_chiefs}/i, @signatures);
-    }
-
     my ($author_ref, $authors_ref) = extract_formatted_signatures(@authors);
     my ($types_ref, $signers_ref) = extract_formatted_signatures(@signatures);
 
@@ -1623,10 +1588,6 @@ sub vcs_find_author {
 
     @lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
 
-    if (!$email_git_penguin_chiefs) {
-	@lines = grep(!/${penguin_chiefs}/i, @lines);
-    }
-
     return @lines if !@lines;
 
     my @authors = ();
@@ -2342,10 +2303,6 @@ sub vcs_file_blame {
 
 		@lines = &{$VCS_cmds{"execute_cmd"}}($cmd);
 
-		if (!$email_git_penguin_chiefs) {
-		    @lines = grep(!/${penguin_chiefs}/i, @lines);
-		}
-
 		last if !@lines;
 
 		my @authors = ();
-- 
2.39.2


_______________________________________________
Ocfs2-devel mailing list
Ocfs2-devel@oss.oracle.com
https://oss.oracle.com/mailman/listinfo/ocfs2-devel
