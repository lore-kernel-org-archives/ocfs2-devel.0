Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF77E277CAF
	for <ocfs2-devel@lists.linux.dev>; Tue, 26 Aug 2025 02:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756176483; cv=none; b=DkEz4oObegMXm8miqnL0+yPtzf+02Wx7+1b0jWhdgDRnOLnerUe1DW9y7loT+3f4mqg0442XX/o0XsDb4HZ1g09Ylevh5cxquhWm9RfMaIIFtkrD/UkziAk2dhHf1bE/zY7+PjUf+WRwnVZI6cm9C7tKfIMdzn2ZyrhNl+ZTtjo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756176483; c=relaxed/simple;
	bh=5O0xZfxdFwvw+gaf0aLZa6bI261Y3F9Srs9/2suiejg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=UuBIT72c8e/m704b6gHnXBtiE3Iiavt4d02HoqwDYbtSVrgZfgcOHJUbwWxN7T0GxNE+beJ2tUJzBLd4VyxaRYs307MQbskvkFLe11GgeyRN4YcJQMuCtLkChGYwBYZQB3Bh45MxT/0ZJ7FJ1eQTrgSTftR3nDZtLclJYoXl+4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CTWkZwEU; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CTWkZwEU"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2468e7c7b30so26640825ad.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 25 Aug 2025 19:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756176481; x=1756781281; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=th8vCaaeH9XGMni4YOrjZYqsp+amesPtImMzW7HsMDA=;
        b=CTWkZwEUbx9bF8BfsSwqKCCgdVRMllVPqwAh0cU48FILGAczg8Q0nAxgI2AnhJ9IDR
         vVSaLpYfkyPOjVHtd8dMIlmkt0Y/GrklavJJYHTRNemTRLZSNx/WsmNibp1AKl3+CqUx
         y/bShUpePYPOJFBecNUo10njzYJNPqFmtzA/qbBXMz9z5fbGA7T0egt3zweW5iSZ1plf
         DlC17O28NoDQG7E0bMvjm4gfXLdya2d/aqg3sGCZ9Dwrc6cyj1K3uARjGptY/k6O8XrK
         lDHJuZYid1mT1T2ABYyVkObRxMfOYRXyYAX/U88nGYrTTf+QxQyJHx7Qul2MBah8/CgM
         aN7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756176481; x=1756781281;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=th8vCaaeH9XGMni4YOrjZYqsp+amesPtImMzW7HsMDA=;
        b=QmcbvVL5Nty0K6h7DathZP08eMB4J9F7T20e7i9chNNY7C+1g1RYYZadGR+msO3cTj
         i4Q/hyqSqPoUtaJv2I6SqGSiLkYsCn2JXOlwIGZsgYlrICltiSQtwpMAaXfm+6hovZ8y
         x9PHaxvd2XlQhR/OiC+EziJnGDtPyGowPjQXZu93t2w8B0/jvC3DfKKRK50gQx8xaQv6
         /fcN95yclzrYU95uNGtodNFMmbf8fSXohqc82atkHyJ0zvHOkeZ5SHxTp7uo8EXQvw2E
         M0Y0Hjm5qBuFROKQtg5W5Hqxb16wA/hX0C/b9skeTgzzgEN+NVfnoECGHR8bT2gkl27X
         Bskw==
X-Forwarded-Encrypted: i=1; AJvYcCVwB/15xPF9o125fjAjxQfuDKW/MQgYtgN5RueYtrqDfCBkqn09RSNo724rcKidaph4A6H78ke0kzqVvA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2DvsB2qolUTk1MEMcNaS5hwh5SdoV10L9rcW0Nh3b3b4kqv5H
	3hLguyawKYFriQGigk8RaZXWS7YpV6DZJ+k1CEauegoPouWVhh/JapPARJiO9i9h
X-Gm-Gg: ASbGnctVaXQvjPTqrgYi3CVmGuK/t7MzDcd5TM+NYFuA74IiuBcIU/a8K9ULXkZkmnV
	nrC7lT7EruvjV7WeMspsnHaOP3wSQGFdKFZjx9noSEUM2WefqSwMiscRTIJJIDFnItbYI94uZFW
	fwrpRs2iG1DzML9rfK7rgUF9J3zOHH4yfdaSy1gznNTgQkjCQpPtQn6Hx2yPhafGUiDqM6Czl71
	DeA/GPCVGYeIqnLh2dto5t0Clf6e+rBNC/lNUoEUQNXoewFWXYGBj+Aaj0pdh+BzU+DBkRQubDN
	cvAV8zJg9jAapEXvB2VhBViWCO5SKP+HNPMcBGX8mNBTEgePEc1z4g7kbq3jzJXMa4XHqG8djBn
	BIi6jrmRaG/xCJYLofpJua88WYOSTZ8Gl
X-Google-Smtp-Source: AGHT+IEx6KgtBSE8/foDuVT3dHGN20n3pJZnNDWiKKGoWzzcY3jyypCclHOCVCFqH6uNDW+YFz2fNw==
X-Received: by 2002:a17:902:f68d:b0:246:c077:980f with SMTP id d9443c01a7336-246c077a4cbmr85993235ad.39.1756176480906;
        Mon, 25 Aug 2025 19:48:00 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3254a1e5888sm8574343a91.12.2025.08.25.19.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Aug 2025 19:48:00 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 75619424E25B; Tue, 26 Aug 2025 09:47:58 +0700 (WIB)
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Documentation <linux-doc@vger.kernel.org>,
	Linux ocfs2 <ocfs2-devel@lists.linux.dev>
Cc: Jonathan Corbet <corbet@lwn.net>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Bagas Sanjaya <bagasdotme@gmail.com>
Subject: [PATCH] Documentation: ocfs2: Properly reindent filecheck operations list
Date: Tue, 26 Aug 2025 09:47:56 +0700
Message-ID: <20250826024756.16073-1-bagasdotme@gmail.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2543; i=bagasdotme@gmail.com; h=from:subject; bh=5O0xZfxdFwvw+gaf0aLZa6bI261Y3F9Srs9/2suiejg=; b=owGbwMvMwCX2bWenZ2ig32LG02pJDBlrpS9/9Ik4/HXKJY3yKf5+Et+X8N8QOSYrs+yHmMKUy iVvfV4t7ChlYRDjYpAVU2SZlMjXdHqXkciF9rWOMHNYmUCGMHBxCsBEHJsZGQ50nH2yjHliy/nE OMYVz+ZvPnfjqd0hyfblvU/f6X/b/52V4b/nmy3T3yvvKbBTfRbQ3RfkfydYJWDOFME/8UF5DG6 nWVkB
X-Developer-Key: i=bagasdotme@gmail.com; a=openpgp; fpr=701B806FDCA5D3A58FFB8F7D7C276C64A5E44A1D
Content-Transfer-Encoding: 8bit

Some of texts in filecheck operations list are indented out of the list.
In particular, the third operation is shown not as the third list
item but rather as a separate paragraph.

Reindent the list so that gets properly rendered as such.

Signed-off-by: Bagas Sanjaya <bagasdotme@gmail.com>
---
 .../filesystems/ocfs2-online-filecheck.rst    | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/filesystems/ocfs2-online-filecheck.rst b/Documentation/filesystems/ocfs2-online-filecheck.rst
index 2257bb53edc1b1..9e8449416e0bee 100644
--- a/Documentation/filesystems/ocfs2-online-filecheck.rst
+++ b/Documentation/filesystems/ocfs2-online-filecheck.rst
@@ -58,33 +58,33 @@ inode, fixing inode and setting the size of result record history.
     # echo "<inode>" > /sys/fs/ocfs2/<devname>/filecheck/check
     # cat /sys/fs/ocfs2/<devname>/filecheck/check
 
-The output is like this::
+   The output is like this::
 
     INO		DONE	ERROR
     39502		1	GENERATION
 
-    <INO> lists the inode numbers.
-    <DONE> indicates whether the operation has been finished.
-    <ERROR> says what kind of errors was found. For the detailed error numbers,
-    please refer to the file linux/fs/ocfs2/filecheck.h.
+   <INO> lists the inode numbers.
+   <DONE> indicates whether the operation has been finished.
+   <ERROR> says what kind of errors was found. For the detailed error numbers,
+   please refer to the file linux/fs/ocfs2/filecheck.h.
 
 2. If you determine to fix this inode, do::
 
     # echo "<inode>" > /sys/fs/ocfs2/<devname>/filecheck/fix
     # cat /sys/fs/ocfs2/<devname>/filecheck/fix
 
-The output is like this:::
+   The output is like this::
 
     INO		DONE	ERROR
     39502		1	SUCCESS
 
-This time, the <ERROR> column indicates whether this fix is successful or not.
+   This time, the <ERROR> column indicates whether this fix is successful or not.
 
 3. The record cache is used to store the history of check/fix results. It's
-default size is 10, and can be adjust between the range of 10 ~ 100. You can
-adjust the size like this::
+   default size is 10, and can be adjust between the range of 10 ~ 100. You can
+   adjust the size like this::
 
-  # echo "<size>" > /sys/fs/ocfs2/<devname>/filecheck/set
+    # echo "<size>" > /sys/fs/ocfs2/<devname>/filecheck/set
 
 Fixing stuff
 ============

base-commit: ee9a6691935490dc39605882b41b9452844d5e4e
-- 
An old man doll... just what I always wanted! - Clara

