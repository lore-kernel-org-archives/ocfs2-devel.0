Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DF3335573
	for <ocfs2-devel@lists.linux.dev>; Fri, 16 Jan 2026 17:21:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768584083; cv=none; b=i4tgGN5B/B+V8sHm5lwdY7BWMvvVrtQXQIAfiY2V5+FoMY9cQ1oNiS6sttuldMNnkRcRMs8fL4XnKfhTCFmuLhfiSXJ+QxakiGQ9s2nySnQM6P2WOx7pBNVWjcSyqXKQC7tpSNue93jHu1nBcrAIBhXe/MDTNpwGofdUb2zBh/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768584083; c=relaxed/simple;
	bh=Xf4JjRB+mAxAAVdinN9sGty1wOzBtYvIa/X7J1pOO8U=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=pXfZqtFCrzqph6et5Z0kaHeLElD1PSJ7hjBt5ZBfYDEaeVA21DpVdOK6AAeCA73rvXlfNiDBbUOSB79jmaEvD3tCbcmE85fu4HZ1V1rl63cHr5/vzfEZ5o/vW+geLKioo+ZS0384LJBrx4I4Z79YUUMGD4k1FBYNlt/HQx1o/Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Um2Ex6fe; arc=none smtp.client-ip=209.85.161.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Um2Ex6fe"
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-661077c4d36so1704583eaf.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 16 Jan 2026 09:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768584081; x=1769188881; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Zf9dSIrVB8N6LEydMPNXWv5oWKXC/LlZlb8Q7vsNEbc=;
        b=Um2Ex6feGWyFTZKu7khfwkA7kgSY0taWVmtEjf4z9yawmweUI+htRN5nON54c258D1
         tsS1YhyLgJ980TwFEeK8oNExzfdz82ukG3JZU6f0y4nVjQBQoJcWG+4Nc02GfU3Xxlty
         1NFUNwv4edIkEy6fUvsTMJ1BKjIr6qLpxwt58yPj9sB/Tj0ZQZMhSgO735ebf+NBnqZ6
         Z6FTAdbzXKZZnbIbpWsN/7pghculNngUC+AgiusKVqEyAgcMaktqFnd+uPl+fgpX8pAW
         F/+36iONPgpqHU7sNU3sSM3qidL0OZsYnkpyfwRQq3LoLOYRhhvXDpF/0LPUQaRc9Sxy
         j6Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768584081; x=1769188881;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zf9dSIrVB8N6LEydMPNXWv5oWKXC/LlZlb8Q7vsNEbc=;
        b=Ap0NmmvX0UnIyG1XnzhjeeU8goZpv7UgiXIkR1jV06oCv7XKuYOym7Ci5F+MXpKlsW
         ZCE/WPWsxGC4Y1piQJoN5c10RJSWdY2fgWUCAaCtP88NtRqQZKD0XC8rmQFy7RX9ZBSd
         ujCR9JOIS4ORg+oDmm+EwiEbLp2rWf5kDObD37ErNqiLpw7JRMF12U1XG6uMRmAywe9f
         wOLn7qqK+LfC3pvxs7+kD3WTn6HAjXlNbPlnNsLgbqHuVhKvh/pW1Iljc90mqhcZ1uDT
         wsw5v7IDLLBgs65CYBYYa8zLXysYJVtsSQZm/nhNuncEdJNOtODzOzipA0eZecCV/r83
         tc6w==
X-Gm-Message-State: AOJu0YxcA5UNiCeDxwYqcu2QydrteOfL6aKrzr0Viz3GGamhRycQOCu+
	6q54U9tuTCPCfReNmzE1/ioOjtIV5YdA/pg8zhmw9+/GMZrtbMaRjkQj
X-Gm-Gg: AY/fxX4lx+fqskltsYTfmc/5GgfvqLfq3FcqBpueQjXEQruYwYaFidM5YnttyGhhTz0
	1dvs1Vnwy+qjbbO19UkncnZJJ/6ktoys+Ru0eNix1ZQURmzDQ7/SReSBgpJ285Q3rqPxOg9WekP
	CAxXjVYIALM99cC3FoUmdvxief/FuV6dLo6Nuw8yjryu7pllBK8fWmctrEPk3YTkZFo9XazNc3j
	kz13GI/CUq7U/rctKFaahTU42ANT4riRZDyDUTWCKohH25gxYg0jb+lbxBlFrkuvHCvJyxtgiB0
	bexG3CLOEqqe0v6znVbC9iMDLCG4rK7IIhBbjDsKAjh9pbAilA0A0lhV0Cu2c5a2s5LWEpcnmlN
	pM16qn3quu84VsA1wve4mZnlm7jyreDUIrO68pE7T1QOnkxshE+X52b4x5t2Q+hvB7OXlNIweWw
	cQa1WBBTl2BOcvtU6sf0A3hzPPx/NzsGnQAHITAhwILjY=
X-Received: by 2002:a05:6820:458b:b0:65c:714e:efc7 with SMTP id 006d021491bc7-661181255ffmr1332935eaf.33.1768584075980;
        Fri, 16 Jan 2026 09:21:15 -0800 (PST)
Received: from newman.cs.purdue.edu ([128.10.127.250])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4044bda443asm2027980fac.22.2026.01.16.09.21.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 09:21:15 -0800 (PST)
From: Jiasheng Jiang <jiashengjiangcool@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	linux-kernel@vger.kernel.org
Cc: ocfs2-devel@lists.linux.dev,
	Jiasheng Jiang <jiashengjiangcool@gmail.com>
Subject: [PATCH] ocfs2: fix slab-out-of-bounds in ocfs2_rotate_requires_path_adjustment
Date: Fri, 16 Jan 2026 17:21:13 +0000
Message-Id: <20260116172113.22143-1-jiashengjiangcool@gmail.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

In ocfs2_rotate_requires_path_adjustment(), the variable 'next_free' is
assigned the value of 'left_el->l_next_free_rec'. This value is then used
to index the 'l_recs' array as 'next_free - 1'.

If the filesystem is corrupted or in an unexpected state such that
'l_next_free_rec' is 0, this leads to an array index of -1, triggering
a slab-out-of-bounds access.

Other functions in alloc.c, such as ocfs2_rotate_leaf() and
ocfs2_update_edge_lengths(), effectively guard against this condition.
This patch adds a similar check to return 0 immediately if 'next_free'
is 0, preventing the out-of-bounds access.

Signed-off-by: Jiasheng Jiang <jiashengjiangcool@gmail.com>
---
 fs/ocfs2/alloc.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/ocfs2/alloc.c b/fs/ocfs2/alloc.c
index 58bf58b68955..b15c6f751d99 100644
--- a/fs/ocfs2/alloc.c
+++ b/fs/ocfs2/alloc.c
@@ -2327,6 +2327,10 @@ static int ocfs2_rotate_requires_path_adjustment(struct ocfs2_path *left_path,
 
 	left_el = path_leaf_el(left_path);
 	next_free = le16_to_cpu(left_el->l_next_free_rec);
+
+	if (unlikely(next_free == 0))
+		return 0;
+
 	rec = &left_el->l_recs[next_free - 1];
 
 	if (insert_cpos > le32_to_cpu(rec->e_cpos))
-- 
2.25.1

