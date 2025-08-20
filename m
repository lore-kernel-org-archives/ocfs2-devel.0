Received: from out162-62-57-137.mail.qq.com (out162-62-57-137.mail.qq.com [162.62.57.137])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD56119F48D
	for <ocfs2-devel@lists.linux.dev>; Wed, 20 Aug 2025 01:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.57.137
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755652011; cv=none; b=ZkU5oXVu68JfT4j5RXV9rhLrDgFAmB97bEoncTqaJljCSnPR+QA9YWwgBnneJhBU3OZFRUuD2Z0bdH9C8Rh4pBXCTg+1VncOi3PSM+bpwgT3Zgy9mgWScAHIKhBa/SFWNpGiWGtMh/QJ/UdXDb8Ytlvzw+Hkrx5jNs/syYnGAow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755652011; c=relaxed/simple;
	bh=8dCUsBKgFZu9Sx/mUQsUP8cJCuew4ZAV1wCt1Is5R0U=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=us3Uu3ShrK5e4c26LcMvmgKTt490oYNZoc3g1XwXRsrM5BsZ169tql2OB47/M1FwT48lmgnF3XRkUlExQNHHA6m238Cgjth8dckH5uiI8irGHc8nVogO6pUvq5cLcliWN3pHRc0A1KhEFx3kSy8n8/gyoP+0C7pu+yp3+J6AGDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com; spf=pass smtp.mailfrom=qq.com; dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b=Z7gpTb8t; arc=none smtp.client-ip=162.62.57.137
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=qq.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=qq.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=qq.com header.i=@qq.com header.b="Z7gpTb8t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qq.com; s=s201512;
	t=1755651703; bh=8dCUsBKgFZu9Sx/mUQsUP8cJCuew4ZAV1wCt1Is5R0U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z7gpTb8t3atDIvUKlwU+ZymQrlf/NiNTfCbU5uZUxZl0KaNHpsP9N0NzfLjUkxNAo
	 nNV1FTD8fbvww/kQBv/lAHZgq/BcxptCCQ6+bh3iFn7+NvF1BmZz+RF4e7CBLxgo6s
	 v4CqES9QoMN6qRNgcc4JUgN1kADQD4NIkis1UDgk=
Received: from pek-lxu-l1.corp.ad.wrs.com ([111.198.230.220])
	by newxmesmtplogicsvrszb16-1.qq.com (NewEsmtp) with SMTP
	id 621CC3F; Wed, 20 Aug 2025 09:01:34 +0800
X-QQ-mid: xmsmtpt1755651694trs4p78zh
Message-ID: <tencent_D46EBC9510E942ED0ECC4078F66E802C390A@qq.com>
X-QQ-XMAILINFO: Nq4zXdVTSZRGu0tTCEDdrMVnQ107P9Z/nC475fWmT4/fQqjDLV5kRPAPykk7Ti
	 0JnXIc7zd1sHo7YmQSTix+7wb9PVLSCWXtLPJLuhcF/IK3XJps6Hsz2gRIAMpGjCj9HmcGG0/6hB
	 5mjEGb6k41Sm/a3CGYJvlc+rmpwwKajceLfi+3nFfUgyWiH/lfjhLb14OVwBPrWVq5YJs7Nu5xb8
	 pOLZNra3gzz19ycq2rS6cmPYikZqaPaq80uDAvAgVT55Wa12/G65ZB0v05HoxGxAfikhJ4oPm2Wi
	 JF4b00eAptbHbC3EWVuaYos+94OS5uRe0rDia9nRRpCaX7mRfCPnsba5HPGlaEsPFeEYySBwb0Uj
	 ylzU7A39Br6ZuUoc8v1nQ4kV+TtZUoTp6M+Q8OImlQQteQGuRWbUv+tmpRtxkHcYwf5ORmm2HIhu
	 LppGKe2yw0DJBhm/GfTWrnmnAMaDbLVQT+amrqiorgwr7HerhZsUCReROHsZQYkeWT1/X2hitbG3
	 8ATqBvUOc/6hiS05uBKkaQ8v2lcKpulBxfMMBzeq+3getq/1T4pPy39CKeQtkjQcZtFLj/mihQjX
	 GCYFVbgTsZ9cALls9rx1y5k7Wuk9i7HFfVKrUfd9zuG3R6oUq4FwGgC6elyUQRC1PoLlwzFUcPDT
	 G9KKBcFOiRStsex3LJcHky7N7QBS4IzMEMM7NUU6G33chnOMm/KOBC6aEF/d892k7PAEkHx4sw9G
	 HSaSbxqL9YRkCDqsMLwP4JLyuq3CH8/1Baxot5KtPJvFfEfoxOCraey8yNe56QJyHYeZgY/zBA5L
	 M41TQdm92L6eXWS6tH1f/q45e5RxY8ieWoPBvwpZ5QbfSD+WwlHc1WS83aX2rt5XdFmYPmjGg5cM
	 BbBlWpIs2+2xKTEVj17cwgo4WqZcyTnr+aZKgP1sjHD6yjFfIhCf91uA/o5u2DWJpCv4IWN7w58e
	 IobhIoZH79W86pT3jHKFn2FaW8ymdJ
X-QQ-XMRINFO: NyFYKkN4Ny6FSmKK/uo/jdU=
From: Edward Adam Davis <eadavis@qq.com>
To: mark.tinguely@oracle.com
Cc: eadavis@qq.com,
	jlbec@evilplan.org,
	joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	mark@fasheh.com,
	ocfs2-devel@lists.linux.dev,
	syzbot+47d8cb2f2cc1517e515a@syzkaller.appspotmail.com,
	syzkaller-bugs@googlegroups.com
Subject: Re: [External] : [PATCH V2] ocfs2: prevent release journal inode after journal shutdown
Date: Wed, 20 Aug 2025 09:01:34 +0800
X-OQ-MSGID: <20250820010133.1334456-2-eadavis@qq.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <a365b3cd-b1b5-4d04-9877-129286345ce0@oracle.com>
References: <a365b3cd-b1b5-4d04-9877-129286345ce0@oracle.com>
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 19 Aug 2025 09:17:40 -0500, Mark Tinguely wrote:
> fixes commit da5e7c87827e8caa6a1eeec6d95dcf74ab592a01
> (v5.15-5-gda5e7c87827). Also for the stable branch?
I think the patch is suitable for all stable branches containing
da5e7c87827e8caa6a1eeec6d95dcf74ab592a01.

BR,
Edward

