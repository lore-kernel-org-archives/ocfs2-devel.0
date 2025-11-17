Received: from mail-yx1-f48.google.com (mail-yx1-f48.google.com [74.125.224.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7E5B315D2F
	for <ocfs2-devel@lists.linux.dev>; Mon, 17 Nov 2025 06:14:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763360095; cv=none; b=LlrNG2kS54gbzfyFxnZIfXIua2bAewJc44sbS+KnGfk5QkuBib/pZpDANW+hxRX1da98zaQRWmp9oWocYswzUhyWs3e2Mhea00YV4MvqFHYVQW5vgcvng2O8lMyWSgYjGtN2hoKt3ZL1agWFIBN4l4grk0B3m6MEk3AEZV8b6Us=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763360095; c=relaxed/simple;
	bh=Rf7oXRusEWUSWjMF+uAAHbwQZVfAquSD1GnstO06vV0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fGAOKaDGgrOW36fsj99ea4H1PtK0yBed9Y8N7YGcTeFIQjpw+wDoji9Yf/VjFGsbC/5BQd/8WtKc+UCQ7cyfRV4X1QjKjKPZYXcHaVf9HHGX8cjAGOiPUI6b21Ugfxz1VrXjqfm+nrF9XOW619br9q7uXQh8gqlVNWDCRw9hZ8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=NVVU5Kpg; arc=none smtp.client-ip=74.125.224.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="NVVU5Kpg"
Received: by mail-yx1-f48.google.com with SMTP id 956f58d0204a3-640d43060d2so3343313d50.2
        for <ocfs2-devel@lists.linux.dev>; Sun, 16 Nov 2025 22:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763360093; x=1763964893; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Rf7oXRusEWUSWjMF+uAAHbwQZVfAquSD1GnstO06vV0=;
        b=NVVU5KpgcCPnwg34VfEpevZi0pgMAj8fTpdhUouwwcjInvSufMqcwLFWJu+pLWYbpy
         OFuF20SCW2zjQgm8wle9dZkfqmikD7EA44IJSeMX6iNv3JFmfEY1dKx7zAY+bRydPXHn
         n6EB+LrmjWyFuHVHySr6mRlSl9Gwxfip9Xz+prOzs57nQE7T6czdjW+ZX5Gb9J/Vxq0/
         /K/adRoGag0eyDX7d8OC/sDx4Una5QmzJa8JssXMw6lU5FlAdaKwyveYZ9k4HmVD8b0K
         utXjO0BJtVlDe+WbrQoLS+fyaVdCE/Od+x7OhaxCWrHc4JvoPagd4yEIec1q0pejJNc3
         bp+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763360093; x=1763964893;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rf7oXRusEWUSWjMF+uAAHbwQZVfAquSD1GnstO06vV0=;
        b=suaQLrrsoCcM2mQFBpgHOmDKIuq/9vYeEzgiO/MZEwU1N4BiBZs0k4G2gzPTwBNzqN
         qZaUssoCkeRX8zuhwlalw08fQabak1iJnYFH1F3vHJKpjqKvYhxyK8Xq5cP9KLEoiuw9
         72nSZXbjd4GA9R5mfH2RN524MLLBLYCt78MyDHx2dJ+iKwfpPNTXppiPk+7fW4+TMvFr
         4Nws/rQrvDxceZWtMxQIiDaWbmIO2j9OADf5+F7nrXe4HaFPozgQI8fNyo95xwAkk4pj
         Due2q9WsaU7n9Gud+koiwNedNS7WTZtMtAV6VNoPPfvXCDYHAF11usoOyc+OS+VzVfDw
         G68g==
X-Forwarded-Encrypted: i=1; AJvYcCWwCEwQ3NNd9UTSshEYdh9Ay9YBvxY73ebZ6qO/8L8mFO/KnK8kMLhGBmRNp+pyO4CikUw7p8dVYDP6Bw==@lists.linux.dev
X-Gm-Message-State: AOJu0YzKqOmrR3nuWiPOnMJjaGoW5BxFc3R9yB97lSC5R/Sodguxpe+2
	d/y4P6yWKVn0CgpOOfkEENyYd0jL64cvY2SwTemp/Y6fKxZIDX7q3op/nFISR+/kDkjmKVl2VWT
	bEy61bhseNil3pv+CIi5RSnKM8FW2dWE=
X-Gm-Gg: ASbGncuxipbaWVLrUfWfL3YgJZpacYomVpBEnAgzDHs1gooUb8rVbqhwjOPfVOuqdBL
	5lSY2xfByeUOGGLwxP7EuNxFMjvBfFJrARaZX5+hZHa130LzwFMeKQbRf032Zdnktp0+1UUXtjq
	D1i4QhJtyvimcdTCOvZCduAt4HvgXsbCh+1+yelR/4Gny6LflTWOqPLWOeGZBbeWp7CZQWrUT+a
	GVfQeacJYpqt5I0PLvVSXBFrMWWp6WjsKnTOzJVethK9lG3lVCr36ZVJcDNNIC/wsORbMr9lUbJ
	loBkHf92tB+ejKyzLRTcnmiNzJZJ
X-Google-Smtp-Source: AGHT+IFB3GAjiDrbmzF7ZNXU4SjvhYZHzMsM+Ywye8UFPbTDy2ZeD0+8xRDOXt4WugxCOde37TmAcgdcokBEB36cpnc=
X-Received: by 2002:a05:690e:1541:20b0:63f:b56e:74c6 with SMTP id
 956f58d0204a3-641e74e6c45mr7653947d50.19.1763360092599; Sun, 16 Nov 2025
 22:14:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251111073831.2027072-1-kartikey406@gmail.com> <undb2iy2lstp7oksnbtkls25ql6un4tbokgp55dfozjwxtfydp@eed726ssveyi>
In-Reply-To: <undb2iy2lstp7oksnbtkls25ql6un4tbokgp55dfozjwxtfydp@eed726ssveyi>
From: Deepanshu Kartikey <kartikey406@gmail.com>
Date: Mon, 17 Nov 2025 11:44:41 +0530
X-Gm-Features: AWmQ_bnUpthLMXn4cIoGnWMk11ZMa5FumhMhlI2px801TSDIoYbflyp7e8e1eVU
Message-ID: <CADhLXY4e0P7PH45Xgn65YkD0qoPL9a+k7xeiS3zyOku_JSTTLA@mail.gmail.com>
Subject: Re: [PATCH] ocfs2: validate xattr entry count in ocfs2_xattr_list_entries
To: Heming Zhao <heming.zhao@suse.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	ocfs2-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	syzbot+ab0ad25088673470d2d9@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"

Hi Heming,

Thanks for the review. I will send Patch v2 soon with the required changes.

Thanks
