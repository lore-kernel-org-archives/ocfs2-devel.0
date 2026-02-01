Received: from www262.sakura.ne.jp (www262.sakura.ne.jp [202.181.97.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF98D1E9B3A
	for <ocfs2-devel@lists.linux.dev>; Sun,  1 Feb 2026 04:21:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.181.97.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769919712; cv=none; b=AnNxthtOPSmoEtRCKN2dEi+P0yPlgAbphZd5CMZonQK9V0bG0f7wLs6lHv1AGVsDI+ECFd/7/mjm6VfmX9Tv0CwC9/+FcdAgwiy34NeaOSrE7/reKLqlIHxL3U4iHzYjfCuzKt9QsiuVYosmoxfm0KAViXWOoHjOdXnTutsUnUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769919712; c=relaxed/simple;
	bh=StceI9wLmKNYr/wUsEuG9SF/+XMl2AxlyKQXIXh03ME=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=h6OMlBvgF7n4NO5bXD0dGKt3Bl7hM09tYqSBX/5PT1yPRtVZzhfJwbEHKu6HHpfWsZRvm2CDhkbUkCtXgwutxcalgaeDeOQG6Aq48RP6sqiEXWSkoph+LmexYBanws4ljS0pfu6U7URYYhYDphQYCFG2KF4i+Q0QI/OZ1TIcsfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp; arc=none smtp.client-ip=202.181.97.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=I-love.SAKURA.ne.jp
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=I-love.SAKURA.ne.jp
Received: from www262.sakura.ne.jp (localhost [127.0.0.1])
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTP id 6114Lnwb018596;
	Sun, 1 Feb 2026 13:21:49 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Received: from [192.168.1.10] (M106072142033.v4.enabler.ne.jp [106.72.142.33])
	(authenticated bits=0)
	by www262.sakura.ne.jp (8.15.2/8.15.2) with ESMTPSA id 6114LnJD018593
	(version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=NO);
	Sun, 1 Feb 2026 13:21:49 +0900 (JST)
	(envelope-from penguin-kernel@I-love.SAKURA.ne.jp)
Message-ID: <f1ab7a8d-e878-4c62-8722-631cbb4b3462@I-love.SAKURA.ne.jp>
Date: Sun, 1 Feb 2026 13:21:49 +0900
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [fs?] possible deadlock in dqget (2)
To: syzbot <syzbot+e7e874621d086b64b4ca@syzkaller.appspotmail.com>,
        ocfs2-devel@lists.linux.dev, LKML <linux-kernel@vger.kernel.org>
References: <6974180a.050a0220.1a75db.0327.GAE@google.com>
Content-Language: en-US
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
In-Reply-To: <6974180a.050a0220.1a75db.0327.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Virus-Status: clean
X-Anti-Virus-Server: fsav204.rs.sakura.ne.jp

ocfs2 developers, I'm waiting for your response on
https://lkml.kernel.org/r/dee1a0fe-7846-466a-a08b-4967929b5f6e@I-love.SAKURA.ne.jp .

#syz set subsystems: ocfs2

