Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D3A321F4C
	for <ocfs2-devel@lists.linux.dev>; Tue, 23 Sep 2025 11:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758626775; cv=none; b=NsO13J30XfCcOumySb10sa4fzB3GKd4F9Tye5lQ0BTC3Gf5oAbDYJUascxhm826Rp0G29ddF8i9DtZrdin8zKkqMGG5Yg2HleaBi7/UFCgGIOZu+0OrQxT2NTJFH0Dm8x6wXFmsqlwPMYSAv/UPwUQVM8ZcIupRsjgN9AZBA3Ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758626775; c=relaxed/simple;
	bh=vAGOBaNyo7UBOtDtuQKzE88y7AhGcv1FK06g/C72pIc=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=fYptdT9AKbbSQAv3lHw9aPbDhdXQegGgbaVz6G2aIkg7mHMbEtDh+If3LfreHOO/syxIOUEcf5x5wLGGGVGUSVV2AP4DfTFx8gF9MqXXfAUtiVeJFDuP1Z6I82mKpLpjhzjx49M9Ee4jrJ6U/F/dT5Geez/tGiqyyGLvJy23yok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sEitXDon; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sEitXDon"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-3ee13baf2e1so3994828f8f.3
        for <ocfs2-devel@lists.linux.dev>; Tue, 23 Sep 2025 04:26:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758626771; x=1759231571; darn=lists.linux.dev;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0ofwUTrC3ZszDdeYuviFmsB1NEgkEhNxkFdaO7tJEVQ=;
        b=sEitXDonIpvIgTd7nZw/DdkBKBzg77Yl7H44FPdHRF/xYEcW5fjohmdrZIVvB5TljU
         nvL6W8KD2O24FNGhuHnLisbKGdI0FYe4zKp6U0c1oO3hHCLlejoOkJAr//DPsW31xabr
         iJdAssdNwDxXE0CiWtCTyStRFjXMvIddYuQBxWvVw+G+T8imdYI0u35sELs6LcRwOc5C
         EsrDDHCcmNk7kudkTwfeWRiaphnFFOhDlOBTEpw1PZFJTZvV/iGkGVZZ3TuowVUt4d7Z
         d3hX2e0f6KPWSUQO86pwUW6umXY8C4jQIDqNfzOQzIfyDweI8mqOGuPvzrTFfOT2Xu2j
         6+YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758626771; x=1759231571;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0ofwUTrC3ZszDdeYuviFmsB1NEgkEhNxkFdaO7tJEVQ=;
        b=VuBNtUR3Gs+nJvrdk7hk8Uk4YdDZyrm6lwLAXjQgn/mhiUCovGeVoNZNsLtBOIY1tV
         AqD2FSW+iT4aXuvltrHzl2raZbgBP0gCXNrDhy4qKDLSkYIJIOZRakcmpNoZRa0xGlfh
         8i3Th21fWCEOSKY0pDA5vzsDe32i6ngnqrv/eiz6e/hw0CYJYAiQXrQLRxr0pDfcHIz0
         6JG3c1SZvCZMsiMDOKrugauC83V/SrUSqCmqPmAEH+MM3VeOhToj//UsmPol35tsvOdE
         lSANdP59kzod3iv1YTyUPRxnUPsW7MIIT86bX0L2xN/geuLiSRZg4lGga0plaIcUAI6e
         mO9w==
X-Forwarded-Encrypted: i=1; AJvYcCVz0hxIiqNjTJXEZd3HwtP3dGMCt9amaFCfoAvCIeXboLslyn2vxbhE11S98aVtoedFW6Ywh5j9kPrjUg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4h5ChUwMciYsf6cTeo0WUUc3n547svAC4/TLuDru8YP0A28dY
	w+rPbDBn2wJJKGBYnpv1m/4SYlbTyB7ICnwcCSkTXA7/WHqkLKav8VuXxLvJSAuHUh8=
X-Gm-Gg: ASbGnctzA4BADtu/rkHoJMJ9uNCcTo8HnAHTbogN8CAurjnTGuI0D83xg3MKFuvrqMW
	KOKnUj3iflYXpLT/moeXO5lm/z6V3er6VbAR7jqMqS6zaFvDlrCL4sRv66m3jlL3sAnTtc7X5LO
	qJNG45XWqocXaoNlXbLNXzNss6IDK+ujogaljzutjfQGaqfPBUXCaQBoWJA8cFqqmCEiR6Jg3z1
	qyIbHyxN3xPFZ912IvfzQCk9gp9ueMoNF2j1Ug2iE+JwqdQRhJqXkTeD8A8ZU6LTm1fwuOCg35E
	5byduVw/wHjPPvRpzBZxvDsAsgLbx16LiUgRhLFByIvs2umLtb1ezSzCENL0pigE6P0yhA12dVO
	uVany9buK0tHlyk6TxqGQf7MHx+1U
X-Google-Smtp-Source: AGHT+IHhOwn6gj+iEexXiGCoorzJAw/kGenVZRN6xxRPh7vGWAqPpdg4EL4KLpicEj1CiwOETeW/FQ==
X-Received: by 2002:a05:6000:1aca:b0:3ec:dd16:fc16 with SMTP id ffacd0b85a97d-405ca39d48bmr1912334f8f.43.1758626771359;
        Tue, 23 Sep 2025 04:26:11 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-464f64ad1b0sm271511895e9.21.2025.09.23.04.26.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 04:26:10 -0700 (PDT)
Date: Tue, 23 Sep 2025 14:26:07 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
Subject: [PATCH] ocfs2: fix double free in user_cluster_connect()
Message-ID: <aNKDz_7JF7aycZ0k@stanley.mountain>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Mailer: git-send-email haha only kidding

The user_cluster_disconnect() function frees "conn->cc_private" which is
"lc" but then the error handling frees "lc" a second time.  Set "lc" to
NULL on this path to avoid a double free.

Fixes: c994c2ebdbbc ("ocfs2: use the new DLM operation callbacks while requesting new lockspace")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
---
 fs/ocfs2/stack_user.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ocfs2/stack_user.c b/fs/ocfs2/stack_user.c
index 765105f1ff8a..be0a5758bd40 100644
--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -1011,6 +1011,7 @@ static int user_cluster_connect(struct ocfs2_cluster_connection *conn)
 			printk(KERN_ERR "ocfs2: Could not determine"
 					" locking version\n");
 			user_cluster_disconnect(conn);
+			lc = NULL;
 			goto out;
 		}
 		wait_event(lc->oc_wait, (atomic_read(&lc->oc_this_node) > 0));
-- 
2.51.0

