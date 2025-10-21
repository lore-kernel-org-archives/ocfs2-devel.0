Received: from forward501a.mail.yandex.net (forward501a.mail.yandex.net [178.154.239.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9903A926
	for <ocfs2-devel@lists.linux.dev>; Tue, 21 Oct 2025 08:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761033717; cv=none; b=BwyyAz4KGeBkTc5D6t3wx1qf1TBRzQzW4U1fCVbH3raE4y1PEYVV79J1hYPHrbyoRYNIetl8MFxlIeTS/n8cv923pcw1h/1/J7wCM+isCHp2ORYV/S5dWqbAbGnIJIHG9LIkPy2I9ugvuPX+JUXLZzOdpDHuzmulaOwy51ivvZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761033717; c=relaxed/simple;
	bh=f7CPouILw6bTo4wH/sYA25440TyHaUc2GQv4+0F3t88=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=n7eDpFNsWum6k7SSVFqvv04lGH0/5jlZXxvw4QxATPJ83RjZ/k/qkHJsXaC7X6P1vfY7Aww44xD1TVRTS0fFtc3gGAu7xD+lyt0nQ56rqp7TZQ6QeAmnh+OXXelFMprF0FevoVgXelglodzDJPAPjsSFAmx0KZGQ+zvUS+EffDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=Lg4MKLgG; arc=none smtp.client-ip=178.154.239.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="Lg4MKLgG"
Received: from mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net [IPv6:2a02:6b8:c1f:582e:0:640:200:0])
	by forward501a.mail.yandex.net (Yandex) with ESMTPS id DF9B380FD6;
	Tue, 21 Oct 2025 11:01:45 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id i1RVCB0LtCg0-G3RwrqO2;
	Tue, 21 Oct 2025 11:01:45 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1761033705; bh=f7CPouILw6bTo4wH/sYA25440TyHaUc2GQv4+0F3t88=;
	h=In-Reply-To:To:From:Cc:Date:References:Subject:Message-ID;
	b=Lg4MKLgGrzmeaiuNPvQfzJeObSbk04F68GGHw7VUYHJlJwSMqhMMrBSgkERaIIIix
	 06GoV5VHCD8XMTkFXjpPatOrzi4YQGuqgn2L78CmU32+5P7dMnXIJSpz/KmEa8aweN
	 nVFeU65Xq24cVtxt1rCwO/FpBCgWZ9q0tkHoehqk=
Authentication-Results: mail-nwsmtp-smtp-production-main-55.vla.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <607750b2-c3a3-4316-8e4d-0cfd0f04e245@yandex.ru>
Date: Tue, 21 Oct 2025 11:01:44 +0300
Precedence: bulk
X-Mailing-List: ocfs2-devel@lists.linux.dev
List-Id: <ocfs2-devel.lists.linux.dev>
List-Subscribe: <mailto:ocfs2-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:ocfs2-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ocfs2: add extra consistency check to
 ocfs2_replay_truncate_records()
To: Heming Zhao <heming.zhao@suse.com>, Mark Fasheh <mark@fasheh.com>,
 Joel Becker <jlbec@evilplan.org>, Joseph Qi <joseph.qi@linux.alibaba.com>
Cc: ocfs2-devel@lists.linux.dev, lvc-project@linuxtesting.org,
 syzbot+4d55dad3a9e8e9f7d2b5@syzkaller.appspotmail.com
References: <18c4bf1b-5860-46ff-9e55-71e715fafdf2@suse.com>
 <20251020150227.210267-1-dmantipov@yandex.ru>
 <5d5f0edc-1251-4c15-8d3c-dc3c8023a871@suse.com>
Content-Language: en-MW
From: Dmitry Antipov <dmantipov@yandex.ru>
Autocrypt: addr=dmantipov@yandex.ru; keydata=
 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
 A/UwwXBRuvydGV0=
In-Reply-To: <5d5f0edc-1251-4c15-8d3c-dc3c8023a871@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTAvMjEvMjUgNDozMiBBTSwgSGVtaW5nIFpoYW8gd3JvdGU6DQoNCj4gT24gMTAvMjAv
MjUgMjM6MDIsIERtaXRyeSBBbnRpcG92IHdyb3RlOg0KPj4gSW4gJ29jZnMyX3JlcGxheV90
cnVuY2F0ZV9yZWNvcmRzKCknLCBjaGVjayB3aGV0aGVyIHRydW5jYXRlIGxvZw0KPj4gbGVu
Z3RoIG1hdGNoZXMgdGhlIG9uZSBjb21lcyBmcm9tIHRoZSBzdXBlcmJsb2NrIHBhcmFtZXRl
cnMgZGVmaW5lZA0KPj4gd2hlbiBtYWtpbmcgYSBmaWxlc3lzdGVtIGFuZCBjdXJyZW50IHJl
Y29yZCBpbmRleCBpcyB3aXRoaW4gdGhlIHZhbGlkDQo+PiByYW5nZSwgdGh1cyBwcmV2ZW50
aW5nIGFuIG91dC1vZi1ib3VuZHMgYWNjZXNzZXMgd2hpbGUgaXRlcmF0aW5nIG92ZXINCj4+
IHRoZSBsb2cgcmVjb3JkcyBiZWxvdy4NCj4+DQo+PiBSZXBvcnRlZC1ieTogc3l6Ym90KzRk
NTVkYWQzYTllOGU5ZjdkMmI1QHN5emthbGxlci5hcHBzcG90bWFpbC5jb20NCj4+IENsb3Nl
czogaHR0cHM6Ly9zeXprYWxsZXIuYXBwc3BvdC5jb20vYnVnP2V4dGlkPTRkNTVkYWQzYTll
OGU5ZjdkMmI1DQo+PiBTaWduZWQtb2ZmLWJ5OiBEbWl0cnkgQW50aXBvdiA8ZG1hbnRpcG92
QHlhbmRleC5ydT4NCj4gDQo+IExHVE0uDQo+IFJldmlld2VkLWJ5OiBIZW1pbmcgWmhhbyA8
aGVtaW5nLnpoYW9Ac3VzZS5jb20+DQo+IA0KPj4gLS0tDQo+PiB2MjogYWRqdXN0IGNvbW1p
dCBtZXNzYWdlIChIZW1pbmcgWmhhbykNCj4+IC0tLQ0KPj4gwqAgZnMvb2NmczIvYWxsb2Mu
YyB8IDEwICsrKysrKysrKysNCj4+IMKgIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25z
KCspDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2ZzL29jZnMyL2FsbG9jLmMgYi9mcy9vY2ZzMi9h
bGxvYy5jDQo+PiBpbmRleCAxNjI3MTFjYzViMjAuLjE0M2NlOGJhNjA3MSAxMDA2NDQNCj4+
IC0tLSBhL2ZzL29jZnMyL2FsbG9jLmMNCj4+ICsrKyBiL2ZzL29jZnMyL2FsbG9jLmMNCj4+
IEBAIC01OTQxLDYgKzU5NDEsMTYgQEAgc3RhdGljIGludCBvY2ZzMl9yZXBsYXlfdHJ1bmNh
dGVfcmVjb3JkcyhzdHJ1Y3Qgb2NmczJfc3VwZXIgKm9zYiwNCj4+IMKgwqDCoMKgwqAgZGkg
PSAoc3RydWN0IG9jZnMyX2Rpbm9kZSAqKSB0bF9iaC0+Yl9kYXRhOw0KPj4gwqDCoMKgwqDC
oCB0bCA9ICZkaS0+aWQyLmlfZGVhbGxvYzsNCj4+ICvCoMKgwqAgaWYgKGxlMTZfdG9fY3B1
KHRsLT50bF9jb3VudCkgIT0gb2NmczJfdHJ1bmNhdGVfcmVjc19wZXJfaW5vZGUob3NiLT5z
YikpIHsNCj4+ICvCoMKgwqDCoMKgwqDCoCBzdGF0dXMgPSAtRUlOVkFMOw0KPj4gK8KgwqDC
oMKgwqDCoMKgIG1sb2dfZXJybm8oc3RhdHVzKTsNCj4+ICvCoMKgwqDCoMKgwqDCoCBnb3Rv
IGJhaWw7DQo+PiArwqDCoMKgIH0NCj4+ICvCoMKgwqAgaWYgKGxlMTZfdG9fY3B1KHRsLT50
bF91c2VkKSA+PSBsZTE2X3RvX2NwdSh0bC0+dGxfY291bnQpKSB7DQoNClVnaCwgdGhlcmUg
c2hvdWxkIGJlIGxlMTZfdG9fY3B1KHRsLT50bF91c2VkKSA+IGxlMTZfdG9fY3B1KHRsLT50
bF9jb3VudCkgc2luY2UNCmFycmF5IGluZGV4aW5nIGFsd2F5cyB1c2VzIHRsLT50bF91c2Vk
IC0gMS4NCg0KRG1pdHJ5DQo=
