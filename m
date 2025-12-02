Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1D520C461
	for <ocfs2-devel@lists.linux.dev>; Tue,  2 Dec 2025 02:28:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764642493; cv=none; b=UXZRDQBE4b9xievfamk3gV5qkuXFD0+yXrxaJoMcKmNa/c95gu3kuPw7LeqlN3Ujw6FAZ0TmrmaTWgkTZF73PxBujGjlUEh47n51wdvrFUMz2Zqkk61cJdUwnsWLLFMIeLAcxbFcJyN/YSBNBscETyHBCE5GXlZHZr9mzgNS2J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764642493; c=relaxed/simple;
	bh=k6DLSLxt2mS92AW9THnTfyPCYL+zu3tAMKUQnsjBdO4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VThEdPvYo3Hibcthww49PP3NsCMKCPTAjJUJISaJMxycFQNcSxCUEpjWQKr532ihlMQ7EIPj8mcmGvZpm/KrGGEG+acQNFDHrVUAxZn2xSKzIHa9e5/zMNh1UhYUJs0e5o+7KYUf32ngEdRB+0jkLKyilCOam78IW0nlnK/4a/o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SOqWu0ux; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SOqWu0ux"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-64312565c10so7642650a12.2
        for <ocfs2-devel@lists.linux.dev>; Mon, 01 Dec 2025 18:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764642490; x=1765247290; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ihzWcZQrPg9oGqI6ksnq5pPm895AlT5PWrtOUGngFrA=;
        b=SOqWu0uxH8SeZUrX1QFoZjOwjiLnP/kcYb19uzbSmb6d5MsNs+LTXG6islvKlYv/V5
         P+nxf8iSTo9x8PIGm0e9uKzeIkQQvommif53d+vAhu9yRbDNfT2uot2/4v312iPH0mWU
         DqBf9o0A3xIMfnLg3RbHcodVEks/C8lgd+m8ymOJ9/qwr5Odo9qnQjksvJe5vZVVFobS
         ivvMmXZQN7McJ2vfM+BlBG8NwnWJfUQthnOePkv6SOzvrdw8+29+sevtM6B3SYm5Jt+v
         ubXWRQYwQnM1Y6x067KFcNZAh0gs+ldxq5UEP5oq5DqXFJp32QFOy+iV3eEcRM6kkPdL
         dlQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764642490; x=1765247290;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ihzWcZQrPg9oGqI6ksnq5pPm895AlT5PWrtOUGngFrA=;
        b=UnhgEOzYzUTOzrWbMUOVpCCLqg0ViIXMFbdgk9JPqU+xIAibzS1Aw/OwNOnocNjpXo
         bKn2vJbr+NeLcpQ2asAc3dlNcyO808McO8TRjtED+hEXNhHxzzb/5rM6ujVFdxfYfot2
         ba1jplA5w5yMDAo/nbVDO0JLLC3TXr4VEdki04NV5vrHw7wC6D2Y9Sa8obpgERjgKYaJ
         Kpdw5j9D7eltmQJhU9+yTBOH/FhZcUCOitvyt5O95ZfFuLIcf7K43QpovXfLGW3gAZb1
         wQTJDKleB/1QvK17sxWHUxZvVfC1voIZNJMZFFNruuI7JZur75SX17Yfep8LS2b1sRer
         Rdqw==
X-Gm-Message-State: AOJu0Ywc/xY9ZUf2OsEa6q7y2AuCIl5b9OI8JE/xVuIBbGdB5t4lOfWk
	/XnlYeUXz8BwDz/xhtn0eLKk2eCQrVxulKH8cussa2qgUDznx5YDhy6Y
X-Gm-Gg: ASbGnctPepcAILYv7UKwAiEiwkIZnDnLEVpck7hYPiwOmPDYn5sm+Uq3zr3t8AAOqdH
	u6dCSpGwFxpIM7p21DiyUpsgN4R6G558LRb2sVKmXz3jxPgAb9KWnRgJ5xzXWrdERem075xvrBf
	rFKYTs9hCLJodJt6fFo8LsBqiavxpSkeZVdDutR4qO5aDxdoRveA04RYXgrFPHLwjCnU5dBSV5I
	7yvzkQoM9gE8gTgdh5RgMvqmJ/rIaTjcGjvzqF+I4DYTc31J9NusA5TslB1rJOTjPL8r81E8f8M
	CvYi+oo4GxnaWBU21ZGuRuUEZNAU1Sq1nBTia89LoVu+N15Mbj/P4yJCLn6cbpfpn/FZBcF9hJ6
	47ZzUfwP1LUQKxjufh5cEfwDas3l2cS/JFH+AD1oAOjgJGzp7ldqJR6BnNZ5uvwlajdqJvnZUoE
	7Gz6pO+4lZito=
X-Google-Smtp-Source: AGHT+IFkadxZWcYPuvorA2AO9KAXSopWYAM81WvbAebNpNfeijF3ooa5mGoe9cC118IBcnJ+Zx8DYQ==
X-Received: by 2002:a17:907:6eac:b0:b73:42e5:a59e with SMTP id a640c23a62f3a-b76c5355c0cmr3001160566b.12.1764642489633;
        Mon, 01 Dec 2025 18:28:09 -0800 (PST)
Received: from eray-kasa.. ([2a02:4e0:2d14:1a1:8eee:b306:2d20:a328])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b76f59a6a5csm1398317766b.41.2025.12.01.18.28.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 18:28:09 -0800 (PST)
From: Ahmet Eray Karadag <eraykrdg1@gmail.com>
To: mark@fasheh.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com
Cc: ocfs2-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	david.hunter.linux@gmail.com,
	skhan@linuxfoundation.org,
	Ahmet Eray Karadag <eraykrdg1@gmail.com>
Subject: [PATCH v2 0/2] ocfs2: Refactor read-only checks to use ocfs2_emergency_state
Date: Tue,  2 Dec 2025 05:27:58 +0300
Message-ID: <cover.1764640432.git.eraykrdg1@gmail.com>
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

Previous-link: https://lore.kernel.org/all/cover.1763337347.git.eraykrdg1@gmail.com/

Ahmet Eray Karadag (2):
  ocfs2: Add ocfs2_emergency_state helper and apply to setattr
  ocfs2: Convert remaining read-only checks to ocfs2_emergency_state

 fs/ocfs2/buffer_head_io.c |  4 ++--
 fs/ocfs2/file.c           | 23 ++++++++++++++++-------
 fs/ocfs2/inode.c          |  3 +--
 fs/ocfs2/move_extents.c   |  5 +++--
 fs/ocfs2/ocfs2.h          | 18 ++++++++++++++++++
 fs/ocfs2/resize.c         |  8 +++++---
 fs/ocfs2/super.c          |  2 +-
 7 files changed, 46 insertions(+), 17 deletions(-)

-- 
2.43.0

