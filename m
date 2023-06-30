Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71971174CA
	for <ocfs2-devel@lists.linux.dev>; Fri, 30 Jun 2023 19:22:47 +0000 (UTC)
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-791a0651fa3so817246241.0
        for <ocfs2-devel@lists.linux.dev>; Fri, 30 Jun 2023 12:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1688152966; x=1690744966;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EX61Snij9v0HMtLXQrwGHF37bKwFwsuRi0p+olHmg8E=;
        b=HMQjY7EqFEHP8kfNJFSw9Dn1yP9g+567RykKiZ5XnH/7zLUh+WOcChoR/YawZtGdpo
         z1pU5IyQylTk53D783rScOQ6RrRFtTDDSj61MwgrIdF8HEEg5OXcBS1eb7XqiXAeMOuy
         5G7wFDg1e5cMAPpGLzBK9bOLd0CnguvXd4ITM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688152966; x=1690744966;
        h=content-disposition:mime-version:message-id:subject:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=EX61Snij9v0HMtLXQrwGHF37bKwFwsuRi0p+olHmg8E=;
        b=JSQPSZdyy+nqo97chsR7sNuF0exCKFT3NiOOYFp7rkUldwcu9k2Zc3T1LdRU5Ve0ce
         IzZllqBV0UDDPzTPh1220fQML7Nf9g/ubW1SMgoZ//6ozkBNh5/viq4iqiFBhkZlyGx/
         jxHaklQuXr/bSHDKlMmE9ZYrva99U3b6sMbaCOOMiCk2nlEvwyV9buPABVWJyyLvUAf+
         1k+Zhubc8qbWLyNSiqkQBAbtzY+iRRgy22BpkcXMGB8I/IKZqQ/9zK8V9t0FGMa53WhK
         xEYHStPC1//suUPPzYZiMqB0RgFZcUYwlledqJD2zy7f+0jYTFjd/KDZgu9Cljf9Kbkp
         n+xg==
X-Gm-Message-State: ABy/qLa6EaRKFOWqXsHHD202gpYCVaejviWWE85M8jHunGs5PFRpD5Kl
	hWZ5Bcg6Ccs5bY3O1QZ610hPRfDKU2M81vhWKUg=
X-Google-Smtp-Source: APBJJlEmBrrV3JWhWCJoEQFnOCM0uRYY5CFBctmCWbSB1P43Sjc6Wb5XFbHApp3fg6kgpZR1MXMZxQ==
X-Received: by 2002:a05:6102:3c5:b0:443:8a7b:f76d with SMTP id n5-20020a05610203c500b004438a7bf76dmr2557479vsq.28.1688152966022;
        Fri, 30 Jun 2023 12:22:46 -0700 (PDT)
Received: from nitro.local ([209.226.106.132])
        by smtp.gmail.com with ESMTPSA id es2-20020a056214192200b00621268e14efsm8215941qvb.55.2023.06.30.12.22.45
        for <ocfs2-devel@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Jun 2023 12:22:45 -0700 (PDT)
Date: Fri, 30 Jun 2023 15:22:37 -0400
From: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To: ocfs2-devel@lists.linux.dev
Subject: Test archive propagation
Message-ID: <20230630-den-tap-guitar-ff1ea3@meerkat>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline

Hello, all:

This message is intended to test archive propagation for this list.
Please ignore.

Best regards,
Konstantin
