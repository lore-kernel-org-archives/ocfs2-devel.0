Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438CF25B31D
	for <ocfs2-devel@lists.linux.dev>; Wed,  3 Dec 2025 03:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764732880; cv=none; b=aG3LjF6/OT3nCOoBJml2gwADJPNip5nxIUFzrLi9zUzcH5be6uMeNv1xETeo2563t/JhHmlbBWDtIM+3c1hUjNdkeDvSzmkRjfAV2DojCGgklaJwkX70DL47wn68evvlHhHi9nrVrLwHRcvsMCjUJAmIhcttjCyaJdcDDNGU08w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764732880; c=relaxed/simple;
	bh=qi15Ah+F44dT8AYjjw3VS3f4C3cM6+jo/K75bZqo14Y=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=TsLbLne7gu/SdPaWuSUyluUmcojTe9VpXxvYnH+u+4JtlJYF61JVLdln6neRYFgX9C74GQdV8+f3VOlnjkK02gTbFXjcsjWWl1h8xhBMzhA1g2fmnmsLJ/RnTNXLQNoKPxau1Z7XT8fXkg7YezbyzEbIBwnFqAzuEUAnsrFFa/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BuOHhGu/; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BuOHhGu/"
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b736d883ac4so877655066b.2
        for <ocfs2-devel@lists.linux.dev>; Tue, 02 Dec 2025 19:34:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764732877; x=1765337677; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Vz4Mn3OPrYWct1u156iuOzaLmXhDBuZgyPBJTaSamrw=;
        b=BuOHhGu/F6KrFplk1FjxS4Uu6em6FeQipwyTAU2+F57+pN9XV4K3Om5lH44q/eUrK1
         yM9OacdKLgZ+9o1P8DsLVxaoB67j3H5fVHBj1IqTEhe2p8QtBeu6Q34lH7m/bZzoFXIh
         jFKM3NeTqdq88/+oI9lbqQ/iBrVY5ly5lvQUmMGwytwHWQLndh5DGVkvZwPpzs7JPZly
         ZqyEV7N8PHsDHPDY6YOvEi+3rMf9QXeBt9p1NKjAbYqznojG4JNOfVF61G8tG8nBWteB
         +4WIuF3E8DJgZwB3tnovMH6erPYsOPOufRHjf0FHchmWWEVPPsjmBOitvQR9/J2QxmqG
         JOww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764732877; x=1765337677;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vz4Mn3OPrYWct1u156iuOzaLmXhDBuZgyPBJTaSamrw=;
        b=RKK5gj9jpvrftfJDgjn25SUnG2m4iI29PCWvcFIsaAMKFA5Am96tSqsgFm8jDwKdQs
         dIyNddLL6j87ajWSZsfTjC4WRwW1d3RXEZOpu3+Xl7s06KLbUStXpaadcFsNzXNkeCXE
         votd7IhdaAqchLnH5OuToBPw8eWf3dPaIluvC+LkyG+ZSSY3ivD0MGsXVYhcciXkylCW
         SP52N1ITYzwE0KbLf7FtESQV73i1koxi5BGjjoYBp1Q+AXinLlCLDKeukEEBmtuAZjQq
         E3ffiJcLvT/WeHBFfvZwwLNKYc3qVrb5Q10QtxPPql+MxnTsbxYDcDqPRVOwt96U7sy2
         V/1w==
X-Gm-Message-State: AOJu0YyOFJeyvAHCLJdkrxkK2XA5oOKaGTGJBLsE4uTzp0ZAUTMK+pfs
	a2kVoym1Eglb4aXgx6ezhXmOx5VNcWrQ7b3hNfT5LJOLFqn3BKqPQtv9
X-Gm-Gg: ASbGncvIx6DfjYtmP66l22G9Cnj4eXedGjQ6DoWDUYU346u1KMzlWA7Cr89rtWq6JNz
	WizxyNp3umdrDJ3wLXNfEhISbQwhMbdsWF5hTtUlrjqSmAzTy8o1IrZJ2m2GL0nkvbXjqbX+K/T
	yITOimAj1jiQzSEX+hQuHleblJxVuWehPwEleKoBOcT5hgep49Z+gDRr0oh75UIt7XrAuEIKMZU
	YkcbYxJb8Vwc2W8xXqFkGvVpLi6EiPu8J8pGgbet8BRKmL0CmRkMyK4aDK51wGMJdyLTDrPMofE
	PMWtQVFX7Ol66s11qESk+lq5+QigbAZSCQBLPgggR0nke50+rOB/QBk45fbQzT3J7jAkjnN6NkV
	ja6L7yZE7H0b/B1ppseRpHlEqDP3zEk8pLgxrOG863yIvXbBO6XxxCXmVWCa6eT9Kl9vqJ5rQeQ
	+z0Bf7OF6i3tIZqdDEO6lqxQ==
X-Google-Smtp-Source: AGHT+IESJrLjVkBR5Rlyo0nu1FgBhpxujkaiZ6n1Lfs3udDV9FjV2q4mHIa2sG+Ioci6DUleCCOmAQ==
X-Received: by 2002:a17:906:c10c:b0:b73:5958:7e6c with SMTP id a640c23a62f3a-b79dbe48f97mr68628766b.3.1764732877356;
        Tue, 02 Dec 2025 19:34:37 -0800 (PST)
Received: from eray-kasa.. ([2a02:4e0:2d14:1a1:acf7:8de5:59bc:44c3])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f5a4b757sm1658570066b.66.2025.12.02.19.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 19:34:37 -0800 (PST)
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	david.hunter.linux@gmail.com,
	skhan@linuxfoundation.org,
	Ahmet Eray Karadag <eraykrdg1@gmail.com>
Subject: [PATCH v4 0/2] ocfs2: Refactor read-only checks to use ocfs2_emergency_state
Date: Wed,  3 Dec 2025 06:34:24 +0300
Message-ID: <cover.1764728893.git.eraykrdg1@gmail.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi all,

Following the fix for the `make_bad_inode` validation failure (syzbot ID:
b93b65ee321c97861072), this separate series introduces a new helper
function, `ocfs2_emergency_state()`, to improve and centralize
read-only and error state checking.

This is modeled after the `ext4_emergency_state()` pattern, providing
a single, unified location for checking all filesystem-level emergency
conditions. This makes the code cleaner and ensures that any future
checks (e.g., for fatal error states) can be added in one place.

This series is structured as follows:

1.  The first patch introduces the `ocfs2_emergency_state()` helper
    (currently checking for -EROFS) and applies it to `ocfs2_setattr`
    to provide a "fail-fast" mechanism, as suggested by Albin
    Babu Varghese.
2.  The second patch completes the refactoring by converting all
    remaining read-only checks throughout OCFS2 to use this new helper.

Previous-link: https://lore.kernel.org/all/cover.1764643790.git.eraykrdg1@gmail.com/

Ahmet Eray Karadag (2):
  ocfs2: Add ocfs2_emergency_state helper and apply to setattr
  ocfs2: Convert remaining read-only checks to ocfs2_emergency_state

 fs/ocfs2/buffer_head_io.c |  2 +-
 fs/ocfs2/file.c           | 14 ++++++++++----
 fs/ocfs2/inode.c          |  3 +--
 fs/ocfs2/move_extents.c   |  2 +-
 fs/ocfs2/ocfs2.h          | 18 ++++++++++++++++++
 fs/ocfs2/resize.c         |  4 ++--
 fs/ocfs2/super.c          |  2 +-
 7 files changed, 34 insertions(+), 11 deletions(-)

-- 
2.43.0

