Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70ACE1386CC
	for <ocfs2-devel@lists.linux.dev>; Tue, 23 Jan 2024 00:36:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970172; cv=none; b=KwjYeEkr1ZBdH9XNv+3/xWXEF4NnWap5pKkWpFjQPFkidSyr7ROFKzWXTGn07BiDWfyw66iRgttT5VI39X+lK3OMAADIG3rBvxDOoEyL1C/bXhY09RLa/ilx0+9C9kwk3OPeafWM4m1kZXf1mmS/Aupnf6RArEUOVYlBDApp3Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970172; c=relaxed/simple;
	bh=ZKqw9ply6ZG+LFAC1qtZzJrjBMrrtfDNMuKnfctsPv4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=mQ4kqnp8FAtMkJq0AEDy+INGcCtZMK9SQfhKMbTxViInVG2fXGXXpGTvQbFiP+qluVfudOftdpRVzix2XMLnh2HveBhXGDUbnFrMMB9hGLAm0sQ2v9GcLZ+Ph/rynPtHsgepJg2uq8/2WFjGQg6cuiPhLSbML1u73B8RyrQjr24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=oLK3jmuq; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="oLK3jmuq"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-3bdb42da0e0so1394996b6e.0
        for <ocfs2-devel@lists.linux.dev>; Mon, 22 Jan 2024 16:36:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1705970170; x=1706574970; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TPUcAg1VyxpFmMGL66jrEY5u/DzPqgMzFU1ubmNn7CA=;
        b=oLK3jmuqddQL8ncW4K7CSQ/FQgDmZEKw1g9G7D30TZfIjfcIAMSysKywrrYcpJhnwK
         qNhySHKXA2YBaJBQjaN5cDCEqMgeaOFER7bOgF3QAYZ1h8HCwWQ6pOJpsldDG9AqGjqY
         Ui3Gygpfk/9mhMqZgA/3POdA/ygfXmAPjb3Cs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705970170; x=1706574970;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TPUcAg1VyxpFmMGL66jrEY5u/DzPqgMzFU1ubmNn7CA=;
        b=cwkgW4f5OXA7gp9v2oyanph27Qifb1p8vfyNA8cWx/64uCYcujMBbxpfo5F0J4YdVn
         Iqg+UG6q7IrrNBSQPBGCVe+r8w2Pkvn3DUAMd5oY6EyimIv9uMaXz8YcJOsnPs7nAjyj
         zi/VKURmW2qB+Ei5WYsMyvrfW1UVbk3cPek7k0rVCAMSLENSLIUqmkt7cRFM2W4WOGqF
         TWt5xjKGVwiyKq6o4SHIRsOj9onwhj3DlCCJNpuQSkqvyAwOVyuH7bx6J0wkPX+D0T6P
         Jx8V161B9rz7Y/ww7xXo2YTam85cpV80oDZRTTIS+MD7ehqUGrYc+iiYSorSRoc/8XA6
         CbQA==
X-Gm-Message-State: AOJu0YymSJ8G/n21XZLAkZ3rVzhCiu9Nv1WfGkSLoF9UrjtYQA/Fb3jY
	9JrE9WZ1LV4cZNbOaAQHL5E9Osc6wEF1PdtRM9aG4Gw9fIVZmFWiRF18ys1Oig==
X-Google-Smtp-Source: AGHT+IHn0rHrTN7AfNo2yWFw9/hZYCK1CweBY/Mf8uXJNSo6ocgMkzbozn7U/SCAROW0O2ojH6f/3g==
X-Received: by 2002:a05:6808:14ce:b0:3bd:bb13:7614 with SMTP id f14-20020a05680814ce00b003bdbb137614mr2240442oiw.4.1705970170029;
        Mon, 22 Jan 2024 16:36:10 -0800 (PST)
Received: from www.outflux.net ([198.0.35.241])
        by smtp.gmail.com with ESMTPSA id i18-20020aa79092000000b006d9a7a48bbesm10140754pfa.116.2024.01.22.16.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 16:36:04 -0800 (PST)
From: Kees Cook <keescook@chromium.org>
To: linux-hardening@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>,
	Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-kernel@vger.kernel.org
Subject: [PATCH 67/82] ocfs2: Refactor intentional wrap-around test
Date: Mon, 22 Jan 2024 16:27:42 -0800
Message-Id: <20240123002814.1396804-67-keescook@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240122235208.work.748-kees@kernel.org>
References: <20240122235208.work.748-kees@kernel.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2026; i=keescook@chromium.org;
 h=from:subject; bh=ZKqw9ply6ZG+LFAC1qtZzJrjBMrrtfDNMuKnfctsPv4=;
 b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBlrwgLsowbEEQcK318jVpYmHDG0BYXC4F28Daev
 cikbLcIvweJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZa8ICwAKCRCJcvTf3G3A
 JncHD/9hJH61vumulCHUP2PnVK997OwzaOOMiiasi/2S5ooDGTgqr1QWT796eZEq0RfrdB3aIP4
 6urDWpWWfpvFMyU9ZMvh+kpv5VGpTTlbV4qjGbd8q+kVRXcf0vkDMwI+9Wukhjf/UtL6k2voweX
 1RQGU4IOK/VUJnhGikPRvMCutiyYARG6TpPQL7EiUYygx2dLd/Ek+kww5PjlWOoyUZD+6ppywAf
 ITX/wVFy96nq+9JmsjEx1wZMsEUQADOeonRWlJb54RJDqLDgLZmrW895mVTNEUyLr3JqGQRXLtj
 32obnvG46VpYu24pgWMb+hOLwXiIdPI4I5Dijfcxbs3Js7fP3G1uSH9xXyD5VtWfnKokabPZwAs
 W0odHp7HVM0/ENU6TRX6J7wLQ7ErFSp6GMsojV4vzWbjYbwHWSl6cqB55KqzT60l861ZbJHLTGd
 gY59JBeiiijfcgl6MZtxE20l0Vp1dq+47Wftp2wzSD2ZzD2iVLA9X4yhTmTziLuPr6ywRHoUtMX
 mfEhqrsklSZJ34IygHfPTmQofap7J3BPgx3oTG6pSNB0ZVswsX7TSZ2DPxbmv7ZGZiIJ7AnPTnP
 SJp1B7jAa6Qci1eJBOWFNfcLlRSn1Btu4+k+9vwoOcXMh1zORuYKVHS1OhWbrKZS/eaUHbypPis JBkFsVbGbKamkXg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit

In an effort to separate intentional arithmetic wrap-around from
unexpected wrap-around, we need to refactor places that depend on this
kind of math. One of the most common code patterns of this is:

	VAR + value < VAR

Notably, this is considered "undefined behavior" for signed and pointer
types, which the kernel works around by using the -fno-strict-overflow
option in the build[1] (which used to just be -fwrapv). Regardless, we
want to get the kernel source to the position where we can meaningfully
instrument arithmetic wrap-around conditions and catch them when they
are unexpected, regardless of whether they are signed[2], unsigned[3],
or pointer[4] types.

Refactor open-coded wrap-around addition test to use add_would_overflow().
This paves the way to enabling the wrap-around sanitizers in the future.

Link: https://git.kernel.org/linus/68df3755e383e6fecf2354a67b08f92f18536594 [1]
Link: https://github.com/KSPP/linux/issues/26 [2]
Link: https://github.com/KSPP/linux/issues/27 [3]
Link: https://github.com/KSPP/linux/issues/344 [4]
Cc: Mark Fasheh <mark@fasheh.com>
Cc: Joel Becker <jlbec@evilplan.org>
Cc: Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 fs/ocfs2/resize.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/resize.c b/fs/ocfs2/resize.c
index d65d43c61857..5cc83e1d54a7 100644
--- a/fs/ocfs2/resize.c
+++ b/fs/ocfs2/resize.c
@@ -423,7 +423,7 @@ static int ocfs2_verify_group_and_input(struct inode *inode,
 	else if (next_free != cl_count && next_free != input->chain)
 		mlog(ML_ERROR,
 		     "the add group should be in chain %u\n", next_free);
-	else if (total_clusters + input->clusters < total_clusters)
+	else if (add_would_overflow(total_clusters, input->clusters))
 		mlog(ML_ERROR, "add group's clusters overflow.\n");
 	else if (input->clusters > cl_cpg)
 		mlog(ML_ERROR, "the cluster exceeds the maximum of a group\n");
-- 
2.34.1

