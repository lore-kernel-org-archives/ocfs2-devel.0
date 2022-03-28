Return-Path: <bounces+ocfs2-devel=archiver.kernel.org@phx1.rp.oracleemaildelivery.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from aib29ajc247.phx1.oracleemaildelivery.com (aib29ajc247.phx1.oracleemaildelivery.com [192.29.103.247])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 168C8C433EF
	for <ocfs2-devel@archiver.kernel.org>; Mon, 28 Mar 2022 03:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=oss-phx-1109;
 d=oss.oracle.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0ahiMglHPixS5gDJ0BD4Oipmv+h/WQxm8LgO+oI79bk=;
 b=IQvYJ/a5xmHzsOZOf8y5+GMhBn6MbZRbv9t/+ltJUt/S43eLxLVvQMgxm4F8wfm+GfLOzopVzc1p
   Tw4gFRstlNuT+IFTw5P1eOOujnKzsUQ5Gl1H4BPRItFOsInhkIs3WDNirl9Xh1c7OKW1uQV3fnvh
   NANyJR1tDSo2aDH14XpNvjvkGAWoC+qCTryjQwNcHFRmV9oU43O1ZZYK8iVF8+6XusOhPcTRVcko
   DZuKqX2gaPaGVozKVC93+3tVIfv1Wxk3F+USONZ+VUlVlsFO+1HzOyQuxnNHUwRf+bo02Eb+PzPg
   hagzMw7p79RZWmDQtiS8hwo+I1ESGau8QNdc6A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; s=prod-phx-20191217;
 d=phx1.rp.oracleemaildelivery.com;
 h=Date:To:From:Subject:Message-Id:MIME-Version:Sender;
 bh=0ahiMglHPixS5gDJ0BD4Oipmv+h/WQxm8LgO+oI79bk=;
 b=m7Q0GH5yFANCDm7LFRTZRTmMUdfe4mXMFm+neaMgzrgicUVLkgspuqrNpLm/B+VK8A3Cd99i/OeM
   +a+6IahpJG2DBrJGTf8god+fHv90qun8Wa00ORraQZnaqqHgA54sAPGHOW2ixjquBYBIS+UrbKrE
   IcL5AHwcXa8Mm1sUYQvcOhsmLpCWCPyCjzPsc4rb0tL9hPOZdeJjze1EtkVQ4Rq6qxuCfUNP4sxE
   yGd6Od7jXy0xVGnKwCy+cINCCir0oBoEgOH6zRK3EJK86u7vrKZAc15wCIMbmxVyx04yL3exKzrW
   m4sm7EM9AuHVHR3fvezpaKr/61abwTu9CgFsYQ==
Received: by omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com
 (Oracle Communications Messaging Server 8.1.0.1.20220222 64bit (built Feb 22
 2022))
 with ESMTPS id <0R9F00FEYQJF15C0@omta-ad1-fd3-102-us-phoenix-1.omtaad1.vcndpphx.oraclevcn.com> for
 ocfs2-devel@archiver.kernel.org; Mon, 28 Mar 2022 03:18:51 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmail.com; s=20210112;
 h=message-id:date:mime-version:user-agent:subject:content-language:to
 :cc:references:from:in-reply-to:content-transfer-encoding;
 bh=GAo6l2+qM3MuxGxPq3iRtJ6KkB9Z2xgPa6w27mOWSFI=;
 b=YAo2bLEvicpXPcHov0xsEU1JTx7D4YC5Fmz1+axqbw+KlvHde1uANuAfMnGXphVe/x
 DF4DSXWuCXwY7o6tOG4gpJopU1iHFwGke3Dt/15XJ7PvTzJKF/GKcnJBEi2A5GA4Zdge
 Z8DJYV0ZeoxgsvsIjTysXUOE75815pAcW8kT6wQYEA0DucN7O1wQQuuW6b6vg278JSnz
 asBJPkaaZm7XjE4BXWrmduGyDI43sMAKlaAgn7QFNv07LVCmIyLkzbcHmSNLH+xCx5x9
 CDjk06pXg1Z9jZv33gk/JQPiC/Q8dMtaz7WkqiR/c3A4O6eSCMhPLdpC2ZYe3EPEl4UV 185Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1e100.net;
 s=20210112;
 h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
 :content-language:to:cc:references:from:in-reply-to
 :content-transfer-encoding; bh=GAo6l2+qM3MuxGxPq3iRtJ6KkB9Z2xgPa6w27mOWSFI=;
 b=tQif7T75UyFdXEtJJ2ZHf1vB900arUfTGvZYYL545hRDiHWmWJDkJ9ftaXLR3M7MEg
 +BeRvXOHf+htM0GesPEYJW6JMJ+SAwC0UTCL+8zsS/7OcRDaXArlF/vKFPF178UkZ5+p
 el6rZbtNcnWD6xK2RaX4OJMUIlJ7QRt6iWoiIB8nBi0SSIZmJW1k3/sp9j3oTAsI8849
 lqzMVnSq1hE6tiRoi67ZlwpY0YBC0/gY51ZPFEevrQOQY2TE25BBbgrnPIYUqULbv7xy
 dOBTxXWi/FaRyeFGvY12YAvVJgeMULmDB0NoDaVD5d32+CzDQUd6PgAdFAUxDT3aZ5Uy Fq6w==
X-Gm-Message-State: AOAM532gbs4euNMY2BH+LrlJHe0bdw0LIqLhlf+MK5sVIkV6YtEoutu4
 8kF99lAH2HYJgkKT9lQ9fV7Bv8Nw+QY=
X-Received: by 2002:a17:902:e845:b0:153:aa16:d74f with SMTP id
 t5-20020a170902e84500b00153aa16d74fmr24392644plg.18.1648437520069; Sun,
 27 Mar 2022 20:18:40 -0700 (PDT)
Message-id: <d1f0c6fb-0ee2-9edd-d35a-cab0d71cd3ae@gmail.com>
Date: Mon, 28 Mar 2022 11:18:36 +0800
MIME-version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.7.0
Content-language: en-US
To: "heming.zhao@suse.com" <heming.zhao@suse.com>,
 Joseph Qi <joseph.qi@linux.alibaba.com>, ocfs2-devel@oss.oracle.com
References: <20220318150401.2411-1-heming.zhao@suse.com>
 <3e2bc324-cfc9-f25e-e5ff-0440f784256b@linux.alibaba.com>
 <9efaf256-4f66-32ca-96ef-7b2617396c27@suse.com>
 <3fb78714-1e48-e72a-c8cf-52ca5723562b@linux.alibaba.com>
 <95977aaa-2ba1-5eb9-8936-450852676e2b@suse.com>
 <c0ca2e8f-adbf-6c42-6346-e6b776857714@linux.alibaba.com>
 <8360e86c-4643-8da7-fa4b-f9b1ea66dfbf@suse.com>
In-reply-to: <8360e86c-4643-8da7-fa4b-f9b1ea66dfbf@suse.com>
X-Source-IP: 209.85.216.50
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10299
 signatures=694973
X-Proofpoint-Spam-Details: rule=tap_notspam policy=tap score=0 mlxlogscore=969
 impostorscore=0 spamscore=0 lowpriorityscore=0 adultscore=0 clxscore=36
 bulkscore=0 mlxscore=0 malwarescore=0 priorityscore=318 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203280018 domainage_hfrom=9724
Cc: vvidic@valentin-vidic.from.hr
Subject: Re: [Ocfs2-devel] [Resend PATCH v3] ocfs2: fix kernel crash after
 mounting when journal doesn't ready
X-BeenThere: ocfs2-devel@oss.oracle.com
X-Mailman-Version: 2.1.15
Precedence: list
List-Id: <ocfs2-devel.oss.oracle.com>
List-Unsubscribe: <https://oss.oracle.com/mailman/options/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel/>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
 <mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
From: Joseph Qi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
Reply-to: Joseph Qi <jiangqi903@gmail.com>
Content-type: text/plain; charset="utf-8"
Content-transfer-encoding: base64
Errors-to: ocfs2-devel-bounces@oss.oracle.com
X-Google-Smtp-Source:
 ABdhPJyJBEetjYRi+DigGKBWv0LzfnW0Ptyk1KZIu/3WgPV+FapXMAi40SPrv/cxcq798s6w/zEJFQ==
X-ServerName: mail-pj1-f50.google.com
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 redirect=_spf.google.com
X-Spam: Clean
X-Proofpoint-ORIG-GUID: eI1W9HEMDGaMZBonnQipz5SeG6ynH5wr
X-Proofpoint-GUID: eI1W9HEMDGaMZBonnQipz5SeG6ynH5wr
Reporting-Meta:
 AAHxx/pB9aY4M2ZWIXWw3GKazho+ORo3GluZjuqOY/yGqyyfKdxxkxy5dICwtjiy
 ciTS8MlKCHQTPf471ADHtWp7O1GYPYIDbS3GVQsAq2q5gh4LffucLptXm7l8V001
 C6ueNltNQplLCOzAUgB0LZvY/CrMNOUw4t0TMU0LlPXXr5fVtMi6AwW3jgUnwiOz
 IYOzwXfAFWWOGxeriQmioCmdVJcXXkO/55FvTCae2YyTUyOY7OE0dqdH8x2mkxzO
 l/V972x1qtvtiOKCIqxLo8eF6RvjLqV+/qKqWVNO4cRodGdFRYt2WNFr5r2QKgxx
 xLekcAdqd1+EqJcj9G3HGEnFn4YgVR9dfigcHZWoiPSuE+7xhwuY8CjZeMY0Tcqg
 FxHI6XsGbadNYWPJwh0Pcfc1bOsJJsQmBWNzwyNP2d+7xWXjK+4OmhgvNu4+QM7W
 Kycywqe4b2K26bCYP548lc6tSPS0RPK+au8Zmva9GWSfuGSWtONFs77brW6XdWih
 q6v92rPUfuAuWtpNNS/73P3+4ltMnd3k5zVb8+VsfjE=

CgpPbiAzLzI4LzIyIDEwOjQ0IEFNLCBoZW1pbmcuemhhby0tLSB2aWEgT2NmczItZGV2ZWwgd3Jv
dGU6Cj4gT24gMy8yOC8yMiAxMDowOCwgSm9zZXBoIFFpIHdyb3RlOgo+Pgo+Pgo+PiBPbiAzLzI4
LzIyIDEyOjU2IEFNLCBoZW1pbmcuemhhb0BzdXNlLmNvbSB3cm90ZToKPj4+IE9uIDMvMjgvMjIg
MDA6MDQsIEpvc2VwaCBRaSB3cm90ZToKPj4+Pgo+Pj4+Cj4+Pj4gT24gMy8yNy8yMiA2OjM3IFBN
LCBoZW1pbmcuemhhb0BzdXNlLmNvbSB3cm90ZToKPj4+Pj4gSGVsbG8gSm9zZXBoLAo+Pj4+Pgo+
Pj4+PiBDb3VsZCB3ZSBzcGVlZCB1cCB0aGlzIGNyYXNoIGZpeGluZz8gSSBjb3VsZCB0cmlnZ2Vy
IHRoaXMga2luZCBvZiBjcmFzaCBhdCBsZWFzdCB0d28gd2F5cy4KPj4+Pj4gRG8geW91IGhhdmUg
YW5vdGhlciBhbHRlcm5hdGl2ZSBwYXRjaD8KPj4+Pj4KPj4+PiBBcyBJJ3ZlIGRlc2NyaWJlZCBp
biBwcmV2aW91cyBtYWlsLCBJIGRvbid0IHdhbnQgdG8gZml4IGl0IGluIHRoZSB3YXkKPj4+PiB5
b3UgcHJvcG9zZWQuCj4+Pgo+Pj4gSSBhbSBPSyB3aXRoIHlvdXIgbWluZCwgYW5kIG9ubHkgaG9w
ZSB0byBmaXggdGhpcyBwcm9ibGVtIEFTQVAuCj4+Pgo+Pj4+IEFuZCBJIGFtIGFmcmFpZCB3ZSBu
ZWVkIGRvIGEgdGhvcm91Z2hseSBjaGVjayBzaW5jZSBJJ3ZlIGZvdW5kIHRoZXJlCj4+Pj4gYXJl
IG90aGVyIGlzc3VlcyBpbiBvY2ZzMl9maWxsX3N1cGVyKCksIGUuZy4KPj4+Pgo+Pj4+IG9jZnMy
X2ZpbGxfc3VwZXIKPj4+PiDCoMKgwqAgb2NmczJfaW5pdGlhbGl6ZV9zdXBlciAvLyBmYWlscyBp
biBjaGVjayBtYXhfc2xvdHMKPj4+Pgo+Pj4+IFRoZW4gb3NiLT5vc2JfbW91bnRfZXZlbnQgaXMg
bm90IHByb3Blcmx5IGluaXRpYWxpemVkLCBhbmQgdGhlbiB3aWxsCj4+Pj4gY3Jhc2ggYXQgd2Fr
ZV91cCgmb3NiLT5vc2JfbW91bnRfZXZlbnQpLgo+Pj4+Cj4+Pgo+Pj4gVGhlIGVycm9yIGhhbmRs
aW5nIGluIG9jZnMyX2ZpbGxfc3VwZXIoKSBpcyB0b28gc2ltcGxlLiBJTU8sIHRoZXJlIG5lZWRz
IHRvIGFkZCBtb3JlCj4+PiBraW5kcyBvZiAiZ290byBsYWJsZSIgb3IgcmVwbGFjZSBzb21lICJn
b3RvIiB3aXRoICJyZXR1cm4iIGZvciBkaXJlY3RseSBicmVha2luZwo+Pj4gaW5pdCByb3V0aW5l
Lgo+Pgo+PiBBZ3JlZSwgd2UgbmVlZCBoYW5kbGUgZXJyb3IgY2FzZXMgbW9yZSBncmFjZWZ1bGx5
Lgo+PiBBbmQgd2UgY2FuJ3Qgc2ltcGx5IGNhbGwgb2NmczJfZGlzbW91bnRfdm9sdW1lKCkgaW4g
ZXJyb3IgaGFuZGxpbmcKPj4gc2luY2UgaXQgaW52b2x2ZXMgdG9vIG11Y2ggYWN0aW9ucy4KPj4g
U28gZG8geW91IGhhdmUgaW50ZXJlc3QgdG8gdGFrZSB0aGlzPwo+Pgo+IAo+IE5PIHByb2JsZW0s
IExldCBtZSB0cnkuCj4gSSB3aWxsIHN0YXJ0IGEgbmV3IG1haWwgdGhyZWFkIGZvciB0aGUgbW91
bnRpbmcgZXJyb3IgaGFuZGxpbmcgc3RvcnkuCj4gCkdsYWQgdG8gaGVyZSB0aGF0LiBZb3UgbWF5
IHNwbGl0IHRoZXNlIGludG8gYSBzZXJpZXMuCkFuZCBJIHdpbGwgdHJ5IG15IGJlc3QgdG8gcmV2
aWV3IEFTQVAuCgpUaGFua3MsCkpvc2VwaAoKX19fX19fX19fX19fX19fX19fX19fX19fX19fX19f
X19fX19fX19fX19fX19fX18KT2NmczItZGV2ZWwgbWFpbGluZyBsaXN0Ck9jZnMyLWRldmVsQG9z
cy5vcmFjbGUuY29tCmh0dHBzOi8vb3NzLm9yYWNsZS5jb20vbWFpbG1hbi9saXN0aW5mby9vY2Zz
Mi1kZXZlbA==
