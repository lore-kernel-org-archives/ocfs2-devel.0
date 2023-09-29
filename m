Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48BE6658A2
	for <ocfs2-devel@lists.linux.dev>; Fri, 29 Sep 2023 19:17:49 +0000 (UTC)
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-690d8c05784so11787189b3a.2
        for <ocfs2-devel@lists.linux.dev>; Fri, 29 Sep 2023 12:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1696015068; x=1696619868; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uDYWsdWil9zbQW5R6gj/5ZmSzR6wTayh9fz7CUaf8pU=;
        b=kYGuDBKY6USXw17hhgN8ZQaYePHUzMTmm1zhsVmo2TdLsW+Sak1lYIG4hnFTTAQQoj
         xBxIsCKpcVxMrQimhNKmiZs4AsVoQQwnVPLCJgNc9eHSQtLWcMFOAHHZXiCQA2qbu9sI
         LJeWf4Gw0M2ZUepWAOzbhBGO97lBMQYd7jwXQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696015068; x=1696619868;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uDYWsdWil9zbQW5R6gj/5ZmSzR6wTayh9fz7CUaf8pU=;
        b=n5Tgk3UgmI+B6/eXMv6Nd6uFmJ446bIlwEAsaMWcXy0oaMfnh0E/Ufq+0PdWxp/XH9
         tPjZX+tPgfsb7gR2/fyM7SP2fX53sDoInHWhYrA6hILVi/4PGqFsPbXBvUD2QIzQINUy
         zkjDRjzmsTGMEJ/tEPFhykBz8bxAZSGnDXa4RjxHmUFs08NOQ2R+BH7cpd+UEuLXLsYt
         hxo6U/vbt61QK7V9MG32RXidvUxD2ZJTSWWWyc2mtCIUXA3W/RnhzE3uaXymib8GUPYy
         d1fBjp/nmEGkstBj49C1L903YxSzC7DcO8zfJMPyopjFPHScCINfX6pdubrkfKGKzpjo
         xOQQ==
X-Gm-Message-State: AOJu0YwGlt2twzRSK2QXz8+TI/VAnMx8e7O1MDy95z1kDTLCMB7ukty9
	S/LxuiPwooDQLBhrpwlvRujh6Q==
X-Google-Smtp-Source: AGHT+IGdsmoNdh/Arkb8UEaGz2niq5l6pVZkZZWHMJonh+QTEtqj7fKdMqUpwLVu/aGM0F0r0Em/BA==
X-Received: by 2002:a05:6a21:a593:b0:14c:ad99:22a9 with SMTP id gd19-20020a056a21a59300b0014cad9922a9mr6139280pzc.32.1696015068592;
        Fri, 29 Sep 2023 12:17:48 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id n3-20020aa79043000000b0068e12e6954csm4745873pfo.36.2023.09.29.12.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Sep 2023 12:17:47 -0700 (PDT)
From: Kees Cook <keescook@chromium.org>
To: Mark Fasheh <mark@fasheh.com>,
	Kees Cook <keescook@chromium.org>
Cc: Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	ocfs2-devel@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Tom Rix <trix@redhat.com>,
	linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev,
	linux-hardening@vger.kernel.org
Subject: Re: [PATCH] ocfs2: Annotate struct ocfs2_slot_info with __counted_by
Date: Fri, 29 Sep 2023 12:17:46 -0700
Message-Id: <169601506493.3012633.12707221094157928597.b4-ty@chromium.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230915201522.never.979-kees@kernel.org>
References: <20230915201522.never.979-kees@kernel.org>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Fri, 15 Sep 2023 13:15:23 -0700, Kees Cook wrote:
> Prepare for the coming implementation by GCC and Clang of the __counted_by
> attribute. Flexible array members annotated with __counted_by can have
> their accesses bounds-checked at run-time checking via CONFIG_UBSAN_BOUNDS
> (for array indexing) and CONFIG_FORTIFY_SOURCE (for strcpy/memcpy-family
> functions).
> 
> As found with Coccinelle[1], add __counted_by for struct ocfs2_slot_info.
> 
> [...]

Applied to for-next/hardening, thanks!

[1/1] ocfs2: Annotate struct ocfs2_slot_info with __counted_by
      https://git.kernel.org/kees/c/7c993785ae63

Take care,

-- 
Kees Cook

