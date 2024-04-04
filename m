Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311C83FB1B
	for <ocfs2-devel@lists.linux.dev>; Thu,  4 Apr 2024 05:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712210098; cv=none; b=fMt5DxKoGzUGtaOjPhbPTW+33sWGYB4VSVPMCf6dDmuH1/a7nGnszfkkABwLWYY3pnEnSTBXj3yPmz9Y2jfhzthOI9E1vhzPuFE8QKkv33WW6Pm5LBnoSww3P0WfR3Ozy9zGzVKGdQduByDlscnD2X/amwlBoDtQCzOz2ak1GMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712210098; c=relaxed/simple;
	bh=vJ0ATcd0TQPGafjCSrFB06NcZW9zccVeJkvsCZU3/vM=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=GY48Ial8Ao6iwLpM+V8A+jIM+LTHuGcaYbliZQydlYYEKCOQ8LieMrzBsYw8xIS30wIyIzoZ9pR/udB7t1orjt9n63jBGSs9IkiUjL4i11T98mYnz7nhS+Pkvc36nRxHz/83fWF+93veIdSi/FAsplcn0RbDM3RWtIcDl3q9EIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=bZI4GNdX; arc=none smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="bZI4GNdX"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2d82713f473so9645541fa.3
        for <ocfs2-devel@lists.linux.dev>; Wed, 03 Apr 2024 22:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1712210094; x=1712814894; darn=lists.linux.dev;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oOmgQTpT1Wl/CBXO5NStZdViKYGx0FyVcwwKBNcWadg=;
        b=bZI4GNdX5o2OuaJ1e7exhGaVjdhmoDooJvC/3rWHWW5sbQl2P6D4p5pZI0KQGaYLOH
         5DCguvc7XprgRGCNJEHSjAFM7UJXJF4eUjiqfC98JAP95l+YLd55oV3ckZ+j8FbJhhR7
         GPbAndO779YJtbq3pRe+h4FoxZlfOATjZdSv/IaoWQXfjxHHpWk+yOg1ydHCMyCikpvv
         8gv+EUAd5V07TUMC2Ix5V+huiucxtusXBHzsKYRdgRtS0RTri8D349X1fCrdy8TmEB8F
         kmFHWn8+kaMT6DL7y+JUjde9vgeh15D1rmrtkP4gdIfXh9KDKJo9H1hHRaYHLav8oBTY
         x9bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712210094; x=1712814894;
        h=to:references:message-id:content-transfer-encoding:cc:date
         :in-reply-to:from:subject:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oOmgQTpT1Wl/CBXO5NStZdViKYGx0FyVcwwKBNcWadg=;
        b=wvoFbHBkNMT5C2ylAf+Ic6IvS30Xqd+4/0Vrs850SRQ+acaaVFARvjx4a3Nvmf2sPU
         dxGIfRw1iA5D7uMxa6vpWcswG1K1yTcnxfh3bgOG8eo2c+UQGkI/D/R/4HTqt/orxMS0
         vuBiM9IbVNzkxqUQ+LrX+PMTkqs1wsnC2NAPxUxDK2DVDdOfWJaUEeWoNHgyW2H1vsfu
         8fyNFVLwVxtHSGMSwha4nhpSi9AqFrOT6u0xMZjd/YDTVkF4iMxrq6Lw6T1AKs+4Ksx2
         YZzS1wBqdsOsyy1E/dsonR/z8S6JxOrL2IUpxTuQK+Z4I/xU+N7FAmyHmKjZy5KTlnWd
         z4Sw==
X-Gm-Message-State: AOJu0YwcsI6oCfrHpqqn7fojj5ZloGXMdqxLxCIb5wujURjGO/kdCa0j
	933IqON2KuGJ+4ZEDxjv0rcqEqrtn/B3dWuvvj5z46XaNYBBOHpJmYfXPlnhe50=
X-Google-Smtp-Source: AGHT+IElztCh69W/5Ol+p9roofrQWPQVkQeI/rUC6K+zVANVKI/I77xeE2hYqLVjcnu0ODHBRFI/MA==
X-Received: by 2002:a2e:8685:0:b0:2d8:3d5e:a73f with SMTP id l5-20020a2e8685000000b002d83d5ea73fmr1370452lji.4.1712210094283;
        Wed, 03 Apr 2024 22:54:54 -0700 (PDT)
Received: from smtpclient.apple (ec2-13-212-91-37.ap-southeast-1.compute.amazonaws.com. [13.212.91.37])
        by smtp.gmail.com with ESMTPSA id u16-20020aa78490000000b006e6529c7d75sm322426pfn.3.2024.04.03.22.54.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 03 Apr 2024 22:54:53 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3774.200.91.1.1\))
Subject: Re: [PATCH v2 0/4] ocfs2 bugs fixes exposed by fstests
From: Su Yue <glass.su@suse.com>
In-Reply-To: <20240403185138.3aaf5aace1b407eff7ed530d@linux-foundation.org>
Date: Thu, 4 Apr 2024 13:54:39 +0800
Cc: ocfs2-devel@lists.linux.dev,
 Joseph Qi <joseph.qi@linux.alibaba.com>
Content-Transfer-Encoding: 7bit
Message-Id: <4CA64332-E3A7-4DA3-93C1-60227FE18EEA@suse.com>
References: <20240402014651.13723-1-glass.su@suse.com>
 <20240403185138.3aaf5aace1b407eff7ed530d@linux-foundation.org>
To: Andrew Morton <akpm@linux-foundation.org>
X-Mailer: Apple Mail (2.3774.200.91.1.1)



> On Apr 4, 2024, at 09:51, Andrew Morton <akpm@linux-foundation.org> wrote:
> 
> On Tue,  2 Apr 2024 09:46:47 +0800 Su Yue <glass.su@suse.com> wrote:
> 
>> The patchset is to fix some wrong behavior of ocfs2 exposed
>> by fstests.
> 
> Thanks.  We should consider which of these fixes should be backported
> into -stable kernels.  For that we should provide, for each patch:
> 
> - A description of the userspace-visible impact of the bug and
> 
Yeah. I should elaborate more in cover letter.

> - A suitable Fixes: target to tell -stable maintainers how far back
> these fixes are needed.
> 
Necessary Indeed.

> Please could we give some consideration to these matters?
> 
Sure. I will do these after vacation in next version.

