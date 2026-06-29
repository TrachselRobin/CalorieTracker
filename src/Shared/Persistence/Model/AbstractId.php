<?php

namespace App\Shared\Persistence\Model;

abstract readonly class AbstractId implements AbstractIdInterface {
    protected int $id;

    final public function __construct(int $id) {
        $this->id = $id;
    }

    public function toInt(): int {
        return $this->id;
    }

    /**
     * @param static|null $other
     */
    public function equalTo(?AbstractIdInterface $other): bool {
        return $other !== null
            && get_class($other) === static::class
            && $other->id === $this->id;
    }

    public function __toString(): string {
        return (string) $this->id;
    }

    public static function toIntHelper(self $id): int {
        return $id->toInt();
    }

    public static function fromIntHelper(int $id): static {
        return new static($id);
    }
}
