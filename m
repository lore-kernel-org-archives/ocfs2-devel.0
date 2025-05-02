Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1FD2146A68
	for <ocfs2-devel@lists.linux.dev>; Fri,  2 May 2025 16:11:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746202293; cv=none; b=Ivhq/M/jbm9YN9UrGPEEuljwzlPDoamz3Mn1JulNuL8kvfWUi74a+bOdWnniFAoRNcPknCNCwo8JvMEO8tqzAyep8fihiVkDa58wUc4rnx3O6e34WKBkDgMyoOP40OPE1HDmks8xGb7ztCsYD1/+kaw0q7fNuAPrEUWHakKcLs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746202293; c=relaxed/simple;
	bh=FpRpQtjRv7U53wWwY4VCfXb19CcJoypmcqGSPRHC3Kk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kVrRHKnmiqRalVUkDzR9NRke8866ecLkebEgalqbUy0KGRntvxHTwIIwR9B56UeB3jW+FEbkVJtwm9gSbCR4tHgEKNoUFnb07PHkE/DlB68DXPbyK4AOEgeDuXGBLV5hb+14q8+7KMuiDwvHI+U/6lBSzTDhFygHOl0lh5Leabo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mYrg8VxT; arc=none smtp.client-ip=209.85.160.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mYrg8VxT"
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-47691d82bfbso54183581cf.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 02 May 2025 09:11:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746202290; x=1746807090; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FpRpQtjRv7U53wWwY4VCfXb19CcJoypmcqGSPRHC3Kk=;
        b=mYrg8VxT0w1VhUJmEX+E7TPtMKoxWQVhRK/1woFEsaVyYaN5PQy7saqN6oPwf5aLr/
         dF3yLCHFWVu9ggcMxF0npjyegJM3ON7CRUqOscMGC9kUe+xNA6cWTqlt9uAaMJdp738K
         T1dgR0NJnfb/QaOvRA1Cg3R/DPS3BB9qgRSAsyHIXA5XVoRufvEgl5A0osauoh77gysh
         +hsYMDLELlmFGo65Pj6zd2u8XxDnb6XqP+u79Hn5qTgcOT5VfbxnDW89rfOnYH2kLAkV
         Nt5Z/nNAy8lRsc5je1D9rPG17ZVFlADYfvNUxUvkCwE2A7Sec5cM5DYUhXyX3EPS1zl6
         vGGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746202290; x=1746807090;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FpRpQtjRv7U53wWwY4VCfXb19CcJoypmcqGSPRHC3Kk=;
        b=vOJN6i2uKH1XmXHAA0S73YHikjL96AoBmT4OXAnC1K1ouOCNl3MAWQ0DqKA6Pe6nL+
         hC5tTwhzGgALoNf2DaRjTsjwEpVyX8KFKPpkKRit3KBgEDzRhaJZ2iRFi5ibfi60kxmL
         OQypmYzEmvSfA1gJtBYEpvGqPHJLEtWuNQtthvme4Qf6/3FSWQ2Z7oMV8h962rKVpyg6
         qlP/MGexqVaJxvK9K2uxcS2MdKe9DZYyhvRoGlKj/fQ2/mabbA5hIKIIfSH/dH2EVgfG
         DYHrqvpT/yyvip8LJ5OAdCQhPtudpR16I79oomIj4fLpVHl8vhZ0q1g8cDFgd2xXheC1
         FJlw==
X-Forwarded-Encrypted: i=1; AJvYcCUdwNhZAe/z7uuYp2yU9/a8zFt1Y6JuV3GAJYBcyezb7q5AOamPC/GbfDtUvFqZIWVs9kUVLJsshC6x/w==@lists.linux.dev
X-Gm-Message-State: AOJu0YxMuv1dkwwMqM+I0nsnmk05Kwh8ZiTEkohk480lN0wwlBw2SzEu
	MkPmf9AngYg5RlS4u9H/8lX1zF1rH+4xKO96bOFiIZOBOwDiYcUTK3+lMRw3jtnEu6xEprKUNa/
	8bPBUWl2n6vZrYTkrJdS+wLNratk=
X-Gm-Gg: ASbGnctlnnVLKKWBgWFjaQh6kkBeJRYHSMTxg0JDQLvEZqdItzCcEpt2PbKTu4/D+KC
	y3qUJkaLyvJqVlCWYiqqnWm205YZdlI83qQicP6ckpnVYs6WRFj2A7xWOYPwDRiRykbj3LtgP4b
	E2JVpbueAsbrBZ2nYpOsPu5XdlHo7/D8unNg==
X-Google-Smtp-Source: AGHT+IGLAcTSARnmJA/Kgr6uTJWmezvLkJPX2YxhNgDW8SpYetDoGiXPi6v2yrZw/2G0zMAf9dBpqWLczPRdekeeSmE=
X-Received: by 2002:a05:622a:1b10:b0:476:60a1:3115 with SMTP id
 d75a77b69052e-48c32dbeb1amr57251421cf.33.1746202290456; Fri, 02 May 2025
 09:11:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250502153742.598-1-zhiyuzhang999@gmail.com> <a3a6443f-2351-4e55-a12e-4d1f28ba7ca4@oracle.com>
In-Reply-To: <a3a6443f-2351-4e55-a12e-4d1f28ba7ca4@oracle.com>
From: Zhiyu Zhang <zhiyuzhang999@gmail.com>
Date: Sat, 3 May 2025 00:11:19 +0800
X-Gm-Features: ATxdqUE7NpAQl6AyGoPFkOH6K2jeAL22Fq0V5d4sv1gugCSgZGARFw0ffPFQ0bI
Message-ID: <CALf2hKsAL=EysQyzgOcztWDLM5X786b9OPPq9sL=oSgamZPjcQ@mail.gmail.com>
Subject: Re: [External] : [PATCH] ocfs2: Fix potential ERR_PTR dereference in ocfs2_unlock_and_free_folios
To: Mark Tinguely <mark.tinguely@oracle.com>
Cc: mark@fasheh.com, jlbec@evilplan.org, joseph.qi@linux.alibaba.com, 
	gregkh@linuxfoundation.org, ocfs2-devel@lists.linux.dev, 
	akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Mark Tinguely,

Thank you for sharing the patch status.

Actually, I reported this bug on March 22nd
(https://lore.kernel.org/linux-fsdevel/CALf2hKtnFskBvmZeigK_=mqq9Vd4TWT+YOXcwfNNt1ydOY=0Yg@mail.gmail.com/T/#u),
but due to not receiving a response from the get_maintainer list and
being quite busy myself, I have not submitted the patch until today.

I am sorry to summit duplicated patch as I do not notice the change in
mainline repo. Please ignore this patch if it boters you.

Best regards,
Zhiyu
