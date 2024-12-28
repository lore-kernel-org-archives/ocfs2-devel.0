Received: from forward500b.mail.yandex.net (forward500b.mail.yandex.net [178.154.239.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE66813B58E
	for <ocfs2-devel@lists.linux.dev>; Sat, 28 Dec 2024 16:39:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735403987; cv=none; b=dqJyyqIsfxAr2NW9ce8vQ71pCOntrOgpfPmCR+AcULXBoKwoyfYCOABDtLhMtmDXwS8FERK3r3qsBVm8EutSFhw7jYf1wwSC4pb67C7YVUHgFyB7JsMklrpUdNm57k1EJLeHYLZOGJTJVrBOcZw9z8zwSNjof+Kv3ezWQwwv8Ko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735403987; c=relaxed/simple;
	bh=3m5MIf0X+qCIbebttgCtVs+FoBW3AIdsjlM3d7TayZY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j9Mk6c8UtlLrJ7EmpZGAnCPqgNVX5/vMe7HF1oiViWXD9D0qY+BQ9RSUE5NqdqeI/GqnCbpN1FCiNAdUVrcJQYBlL56Zbe5C5541PMole5OeiVO/jpqAvMdck8A2zudOg0QRG11zfAeIu/dJA9JFueE5u6HGaXUpL5X8E6tNqK8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=wgKftTxp; arc=none smtp.client-ip=178.154.239.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="wgKftTxp"
Received: from mail-nwsmtp-smtp-production-main-25.sas.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-25.sas.yp-c.yandex.net [IPv6:2a02:6b8:c11:992:0:640:7835:0])
	by forward500b.mail.yandex.net (Yandex) with ESMTPS id 5D12060FC4;
	Sat, 28 Dec 2024 19:33:18 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-25.sas.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id CXekE0FOq0U0-sPZLZwHP;
	Sat, 28 Dec 2024 19:33:15 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1735403597; bh=qnPsrnAhf/fBhsq+yMBPT4bOiUjKnjEfKx2edGi36FI=;
	h=In-Reply-To:To:From:Cc:Date:References:Subject:Message-ID;
	b=wgKftTxpjEVJMPUvncRN3BxfdgkrrChomO6Bni0tzz10mHup0Tw7cMvr4nvEFn4ud
	 Npxbsk1TszHGSBNAQqhEqy080tsp9D0KafLPgQcSAGoAPUjddI5ajstFfDXf+/dwYq
	 RfjLFQ+2S24zscYt66hRI2GkJgUMr3OO8Es+ljfg=
Authentication-Results: mail-nwsmtp-smtp-production-main-25.sas.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <e62a8e43-015a-4b3d-a018-641ecde36962@yandex.ru>
Date: Sat, 28 Dec 2024 19:33:11 +0300
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ocfs2: uncache inode after ocfs2_search_dirblock() search
 failure
To: Joseph Qi <joseph.qi@linux.alibaba.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+7aef76bdb53b83d62a9e@syzkaller.appspotmail.com
References: <20241227130717.144988-1-dmantipov@yandex.ru>
 <844e9f34-1ef8-49ef-9f42-54fdeeefc18d@linux.alibaba.com>
Content-Language: en-MW
From: Dmitry Antipov <dmantipov@yandex.ru>
Autocrypt: addr=dmantipov@yandex.ru; keydata=
 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
 A/UwwXBRuvydGV0=
In-Reply-To: <844e9f34-1ef8-49ef-9f42-54fdeeefc18d@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/28/24 3:27 PM, Joseph Qi wrote:

> Hi, don't see the relationship between above logic and the triggered
> bug.
> Could you please elobrate more how it happens?

As triggered by the syzbot's reproducer, the problem is initiated by
'mknodat()'...

-> mknodat()
  ...
  -> filename_create()
   ...
   -> ocfs2_lookup()
    -> ocfs2_find_files_on_disk()
     -> ocfs2_find_entry()
      -> ocfs2_find_entry_id()
       ...
       -> ocfs2_read_inode_block()
        -> ocfs2_read_blocks()
         -> ocfs2_set_buffer_uptodate()    ;; [1] Buffer head is now cached
       ...
       if (found == 1)
               return di_bh;               ;; Buffer head will be used
       /* Hmm..... */                      ;; [2]
       brelse(di_bh);                      ;; [3] Buffer head is now unused

...with followed 'ioctl()':

-> ioctl(..., OCFS2_IOC_GROUP_ADD, ...)
  -> ocfs2_ioctl()
   -> ocfs2_group_add()
    -> ocfs2_read_blocks_sync()
     -> ocfs2_set_new_buffer_uptodate()    ;; OOPS [4]

OOPS at [4] happens becase the corresponding buffer head is not actually
"new". It was "new" at [1] but was not exprunged from the inode cache
before 'brelse()' at [3]. I.e. OCFS2 cache has an inconsistent view of
the data provided by the block layer, and it is expected that adding
'ocfs2_remove_from_cache()' at [2] should fix this problem.

Dmitry

