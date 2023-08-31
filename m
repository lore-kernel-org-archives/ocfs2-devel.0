Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EDD19BB8
	for <ocfs2-devel@lists.linux.dev>; Thu, 31 Aug 2023 19:38:38 +0000 (UTC)
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-79536bc6697so43865039f.1
        for <ocfs2-devel@lists.linux.dev>; Thu, 31 Aug 2023 12:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693510717; x=1694115517; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1ki/OwjIU18DtuVHU8h+/teFMT7QJKmhWe1t8w4B3+I=;
        b=aX2TDBfMd/n8bVRULP0MpX6tfAuF+XdZcHUTXY8vJy0J9BZgpSoXhMHQNMKREGxSO4
         1VanZ2HpenP7+s9ocsiMBmjuD4rrFC6hey2I4hHSn/tkT9RvchIUgUkZ6lnlpD9SI0/V
         Ig7lBgGCxaNR6ZbX07VVvs2YpM9rBT1AVEbWw3Tkyc4WxpJeF9PpfJi/xC+jWW4wG/dB
         9zWZwDdd0mdXY2JD27e/0V5p5f4M/rT9TLLWcNW59JTfTKMXlxYQRA7jwGPn6odIJmiV
         xR7bS2O6rMOjE5nKOBAbqJHSPqu1DPilVMvTE+MRte/EUXhJWcDr01Xv7zsHF/c0vEv/
         Zg+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693510717; x=1694115517;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1ki/OwjIU18DtuVHU8h+/teFMT7QJKmhWe1t8w4B3+I=;
        b=kSBboxnI9yzB4FFv6gk8wgTlYJQotEg7Hw40oUGmqLZT7n6ge0GM5NYwawExL1KG4S
         YFzFpdBmB8A+WnWyg9+tJR1gFJLba58hQYC1kbaNSUuSVoOAuQPxqQpdb3cYEbHXahWK
         qGcLXNQxEaU8VDEHJRwGdUGP67xcdMQc3ynHxRwXN1Ch8Q64+WUBvRFunfM8cy0JkeZu
         A9q1Ye7p9eQZ/xjQODE9se9ABw8/vHAsriG4RPKYBUCGv6tOLw7SqpD7NO6l/IPGrovi
         5wNUpQMUI2dGzsdVBF6bf7Khyutz2sXbkgp22a/boKHm4lSIqz4yTp14etcBJ5odopB8
         byPg==
X-Gm-Message-State: AOJu0Ywjkza0PKEHZyro5WVL7h3nL+Hjfq5qFgcAwYjhdbH3O3dU2CUe
	7GuWrYhFZGEBxX6Ti1UNMqI=
X-Google-Smtp-Source: AGHT+IGvlsa8+EI3f6HZsE4SZNDJ3JjIgHosSPzt0rFM0ScC3i7qQ67POY4bnNCVUgtcIdCO4Em9Cw==
X-Received: by 2002:a5e:c80f:0:b0:783:5209:c01 with SMTP id y15-20020a5ec80f000000b0078352090c01mr224313iol.17.1693510717430;
        Thu, 31 Aug 2023 12:38:37 -0700 (PDT)
Received: from azeems-kspp.c.googlers.com.com (161.74.123.34.bc.googleusercontent.com. [34.123.74.161])
        by smtp.gmail.com with ESMTPSA id gc10-20020a056638670a00b0042b39f1c3d2sm579001jab.144.2023.08.31.12.38.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Aug 2023 12:38:37 -0700 (PDT)
From: Azeem Shaikh <azeemshaikh38@gmail.com>
To: Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Kees Cook <keescook@chromium.org>
Cc: linux-hardening@vger.kernel.org,
	Azeem Shaikh <azeemshaikh38@gmail.com>,
	ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Dave Chinner <dchinner@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2] fs: ocfs2: Replace strlcpy with sysfs_emit
Date: Thu, 31 Aug 2023 19:38:27 +0000
Message-ID: <20230831193827.1528867-1-azeemshaikh38@gmail.com>
X-Mailer: git-send-email 2.42.0.283.g2d96d420d3-goog
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

strlcpy() reads the entire source buffer first.
This read may exceed the destination size limit.
This is both inefficient and can lead to linear read
overflows if a source string is not NUL-terminated [1].
In an effort to remove strlcpy() completely [2], replace
strlcpy() here with sysfs_emit().

Direct replacement is safe here since its ok for `kernel_param_ops.get()`
to return -errno [3].

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
[2] https://github.com/KSPP/linux/issues/89
[3] https://elixir.bootlin.com/linux/v6.5/source/include/linux/moduleparam.h#L52

Signed-off-by: Azeem Shaikh <azeemshaikh38@gmail.com>
---
v2:
 * Removes patch [1/2] which replaced module_param_call with module_param_cb.
 * Use sysfs_emit instead of strscpy.

v1:
 * https://lore.kernel.org/all/20230830215426.4181755-1-azeemshaikh38@gmail.com/

 fs/ocfs2/dlmfs/dlmfs.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/ocfs2/dlmfs/dlmfs.c b/fs/ocfs2/dlmfs/dlmfs.c
index 81265123ce6c..b38776ba3306 100644
--- a/fs/ocfs2/dlmfs/dlmfs.c
+++ b/fs/ocfs2/dlmfs/dlmfs.c
@@ -80,8 +80,7 @@ static int param_set_dlmfs_capabilities(const char *val,
 static int param_get_dlmfs_capabilities(char *buffer,
 					const struct kernel_param *kp)
 {
-	return strlcpy(buffer, DLMFS_CAPABILITIES,
-		       strlen(DLMFS_CAPABILITIES) + 1);
+	return sysfs_emit(buffer, DLMFS_CAPABILITIES);
 }
 module_param_call(capabilities, param_set_dlmfs_capabilities,
 		  param_get_dlmfs_capabilities, NULL, 0444);
--
2.42.0.283.g2d96d420d3-goog


