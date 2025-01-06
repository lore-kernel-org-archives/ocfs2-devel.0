Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 353E81D6DA1
	for <ocfs2-devel@lists.linux.dev>; Mon,  6 Jan 2025 14:01:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736172102; cv=none; b=t/q5Qc7/5Ezov5GmE1ENrA4FTXsd84o1JpSMb+W+Tqm8vatzPKlNlyiXHmyqt0pM1x9cUDElsiNwRqApC673XKfR7vFBQeQ/w6saC/yzuLeX/2S0M1hlr1f4ELfdW9HSrviI7encFIOp2QqkyPgHwPvSrvoEy/yv4CzOqjMpxbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736172102; c=relaxed/simple;
	bh=8CLu5T5/ZXNEEQadnXyb7W+lzjIG9jU7ZatkGT382D4=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=jcp6epGxKJWbNhYpaWZgIS18o4AjCdmqTM1lRn3aSnas3NuxrNuqb6U6DWbFmSelcba4JmNJ6GRrC92ksFyvuy0Pfk8pdLQlBaaPvbCXJJ+H+YhCKqJY0Qhj3//tq0+q5pSYfcU41UPpoXzRonX2/4rsR+43JJznCK+sd8S4WFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ejh7WY6j; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ejh7WY6j"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-385eed29d17so6812739f8f.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 06 Jan 2025 06:01:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1736172097; x=1736776897; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vZrjYhLCiRn3Tt2/eeNEnVTraUXU06j8NKj9J6yad7o=;
        b=ejh7WY6jOVIAIzRkH7kuwY5iQEkiN1XalxQ37328VIiVc6eP5yo1yakaMxM+lk6RdT
         VJh3OI+A/QsCiSQU9dnetwDA5AFZ+Ww2VCzDewMQh3dm3mwAjW4HcuuWXj/7ARWHQarO
         /uqT25ab1IgoD14g5gt30oCi3xaTlKW9u2ab4tkhNr9TBXaD9+T79NsPsxgGCGcRXbv8
         c9uYIjEkGUmjnpEcJsJOqWB9FKIjdSyu+s6A2PTMPOY8xnC7ONUxfRKeQb19/ro/e//d
         puE8rfMx1WckdhPrdEq3XSIMMff0u6qIUT/1WKf5PGh7vjSOt/aZW19oC21sxLANYpIA
         G/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736172097; x=1736776897;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vZrjYhLCiRn3Tt2/eeNEnVTraUXU06j8NKj9J6yad7o=;
        b=P7DDmFZKr8xDjgBI8o+KAimggqpCjBWeq88SnPk5z7oX/fdTeNLpkxrIScLJxPILIS
         qp+1DcvC7QiUkl8zWiqWnj9NVpkbNOj6R7H3SrERau2KJSVVoL7v/BAEtogdULgpcrwm
         Iu0ELrqArkl0DlF8l4VaIYOR3Xoxq73gyem2x+s5WBKV5eNRKjHecaSSQSKY9EcNM0cF
         3zFNSL7CdzsVFD9P6QxBhKcxQleJxie/cbIn8e1aKtxf9nwvv5MLzZn6myKjoY7R3FRX
         E42EZouWnPiuUVbSRvWlOU7YhkDozCLU3zMjxMXTHvGjB01IwBphIAlDT8p04790C/LV
         CN7A==
X-Gm-Message-State: AOJu0YzNiWsg3Am758BG/3cSS6LOGPy1+8VuphNzikusDByrB7gVoWc7
	dzXbpgaxkC/475rvM+t/RopdCYBjW5jgjBF6iAgwvxUEncfaqjL3wsfo/cXByoQ=
X-Gm-Gg: ASbGncvsGx2hA0LBb2TtONF0AZIBbAsnIN4h6ovcGQbEhXchL3vRbzTW4X2kf3DQzzo
	dYyDy7oYoYsoUP9O03nBpktnmFELAiLWqTh0cY0E38bykvXds4g0HBvxGp9BzzPKlDiVxcUufmj
	prLBqRR/4pWw/iOUAnnKKz9APfOlFS9FGT5zj/N8BrzEs9TCSQvnBuiVrKYBDuEfqyiuLx5TDY6
	szMCjdGsHyM1FxOSG7n/32n5wuHW+Hd7vc9a/w9TIvKkU83VHuk1kln
X-Google-Smtp-Source: AGHT+IH+q+sj5LXu1ejTyCJXLQp0DM6JJ+q8LRi6VNoUBPz+sLvSxDc4MxT6XcIf0lJgxw2uEd4EHw==
X-Received: by 2002:a05:6000:2ce:b0:386:3803:bbd8 with SMTP id ffacd0b85a97d-38a223fef75mr48178486f8f.59.1736172097135;
        Mon, 06 Jan 2025 06:01:37 -0800 (PST)
Received: from MacBookPro.lan ([23.247.139.15])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-7b9ac2bbfadsm1511804785a.15.2025.01.06.06.01.35
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 06 Jan 2025 06:01:36 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: fstests@vger.kernel.org
Cc: ocfs2-devel@lists.linux.dev,
	Su Yue <glass.su@suse.com>
Subject: [PATCH] generic/420: skip test for ocfs2
Date: Mon,  6 Jan 2025 22:01:31 +0800
Message-Id: <20250106140131.91946-1-glass.su@suse.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

ocfs2 doesn't support fallocate with
mode=FALLOC_FL_KEEP_SIZE|FALLOC_FL_PUNCH_HOLE so skip it.

Signed-off-by: Su Yue <glass.su@suse.com>
---
 tests/generic/420 | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tests/generic/420 b/tests/generic/420
index edd9655fd3a3..e67442f8979b 100755
--- a/tests/generic/420
+++ b/tests/generic/420
@@ -15,6 +15,7 @@ _begin_fstest auto quick punch
 
 
 # Modify as appropriate.
+_supported_fs ^ocfs2
 _require_test
 _require_xfs_io_command fpunch
 
-- 
2.47.1

